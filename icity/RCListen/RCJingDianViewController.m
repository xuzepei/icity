//
//  RCJingDianViewController.m
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJingDianViewController.h"
#import "RCHttpRequest.h"
#import "RCJianJieViewController.h"
#import "RCJiuDianViewController.h"
#import "RCMeiShiViewController.h"
#import "RCYuLeViewController.h"
#import "RCXiangCeViewController.h"
#import "RCYuLeViewController.h"
#import "RCXiangCeViewController.h"
#import "iToast.h"
//#import "BNTools.h"


#define VIDEO_HEIGHT 180.0f
#define WEATHER_HEIGHT 52.0f
#define FUNCTION_HEIGHT 437.0f
#define SCROLLVIEW_CONTENT_VIEW_HEIGHT 670.0f

#define SHARE_TAG 112

@interface RCJingDianViewController ()

@end

@implementation RCJingDianViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if(nil == _videoIndicator)
        {
            _videoIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _videoIndicator.hidesWhenStopped = YES;
            _videoIndicator.center = CGPointMake([RCTool getScreenSize].height/2, [RCTool getScreenSize].width/2);
        }
        
        if(nil == _maskView)
        {
            _maskView = [[RCPlayerMaskView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, VIDEO_HEIGHT)];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.item = nil;
    self.videoPlayer = nil;
    
    
    if (self.videoIndicator) {
        [self.videoIndicator removeFromSuperview];
    }
    self.videoIndicator = nil;
    
    self.scrollView = nil;
    self.content = nil;
    
    self.functionView = nil;
    self.toolbar = nil;
    
    self.shareItem = nil;
    self.favItem = nil;
    
    self.maskView = nil;
    self.playButton = nil;
    self.restoreButton = nil;
    
    self.shareView = nil;
    self.cancelShareButton = nil;

    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //[self initVideoPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    self.title = [self.item objectForKey:@"jd_name"];
    
    //    if(self.playButton)
    //       [[RCTool frontWindow] addSubview:self.playButton];
    
    [self updateContent:self.item];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    self.title = nil;
    
    
    [self clickedCancelShareButton:nil];
    //    if(self.videoIndicator)
    //        [self.videoIndicator removeFromSuperview];
    
    if(self.isPlaying)
    {
        [self clickedPlayButton:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initScrollView];
    
    [self initVideoPlayer];
    
    [self initWeatherView];
    
    [self initFunctionView];
    
    //[self initToolbar];
    
    [self initButtons];
    
    if(self.shareView)
    {
        self.shareView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
        
        [self.view addSubview:self.shareView];
    }
    
    if(self.cancelShareButton)
    {
        self.cancelShareButton.layer.borderColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00].CGColor;
        self.cancelShareButton.layer.borderWidth = 1;
        self.cancelShareButton.layer.cornerRadius = 5.0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    if(self.isLoading)
        return;
    
    self.item = item;
    
    self.title = [self.item objectForKey:@"jd_name"];
    
    NSString* jd_id = @"";
    if(self.item)
        jd_id = [self.item objectForKey:@"jd_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jdinfo&jd_id=%@&token=%@",BASE_URL,jd_id,[RCTool getDeviceID]];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:nil];
    if(b)
    {
        self.isLoading = YES;
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    self.isLoading = NO;
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        if([RCTool hasNoError:result])
        {
            NSDictionary* data = [result objectForKey:@"data"];
            if(data && [data isKindOfClass:[NSDictionary class]])
            {
                self.content = data;
                
                if(self.content)
                {
                    NSString* scflag = [self.content objectForKey:@"scflag"];
                    if([scflag isEqualToString:@"1"])
                        self.isFaved = YES;
                    
                    if(self.functionView)
                    {
                        [self.functionView updateContent:self.content];
                    }
                    
//                    if([self play])
//                    {
//                        if(_maskView)
//                            [_maskView.videoIndicator startAnimating];
//                        //                        [[RCTool frontWindow] addSubview:self.videoIndicator];
//                        
//                        self.isPlaying = YES;
//                        
//                        [self.playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
//                    }
                }
                
                [self updateFavBarItem];
            }
        }
        
        if(self.weatherView)
            [self.weatherView updateContent:self.content];
    }
}

#pragma mark - Scroll View

- (void)initScrollView
{
    if(nil == _scrollView)
    {
        CGFloat height = [RCTool getScreenSize].height;
        if([RCTool systemVersion] < 7.0)
            height -= NAVIGATION_BAR_HEIGHT;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, height)];
    }
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView setContentSize:CGSizeMake([RCTool getScreenSize].width, SCROLLVIEW_CONTENT_VIEW_HEIGHT)];
    self.scrollView.showsVerticalScrollIndicator = NO;
}


#pragma mark - Video Player

- (void)initVideoPlayer
{
    if(nil == _videoPlayer)
    {
        _videoPlayer =
        [[MPMoviePlayerController alloc]
         initWithContentURL:[NSURL URLWithString:@""]];
        
        [_videoPlayer setControlStyle:MPMovieControlStyleNone];
        [_videoPlayer setScalingMode:MPMovieScalingModeFill];
        [_videoPlayer setFullscreen:FALSE];
        
        //设置MPMovieSourceTypeStreaming，如果没有网络连接时，会报异常
        [_videoPlayer setMovieSourceType:MPMovieSourceTypeStreaming];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(moviePlayerLoadStateDidChange:)
         name:MPMoviePlayerLoadStateDidChangeNotification
         object:_videoPlayer];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(moviePlayBackDidFinish:)
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:_videoPlayer];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTap:)];
        oneTap.delegate = self;
        [oneTap setNumberOfTapsRequired:1];
        [_videoPlayer.view addGestureRecognizer:oneTap];
        [oneTap release];
    }
    
    _videoPlayer.view.frame = CGRectMake(0, 0, [RCTool getScreenSize].width, VIDEO_HEIGHT);
    
    [self.scrollView addSubview:_videoPlayer.view];
}

- (BOOL)play
{
    if(nil == self.content)
        return NO;
    
    NSString* urlString = [self.content objectForKey:@"jd_video_m3u8"];
    
    if(0 == [urlString length])
    {
        return NO;
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //urlString = @"http://shop.4gfy.com/static/banner/icity.mp4";
    BOOL isMP4 = NO;
    NSRange range = [urlString rangeOfString:@".mp4" options:NSBackwardsSearch|NSCaseInsensitiveSearch];
    if(range.location != NSNotFound)
        isMP4 = YES;
    
    NSLog(@"video url:%@",urlString);
    
    NSURL* url = [NSURL URLWithString:urlString];
    if(_videoPlayer)
    {
        if(isMP4)
            _videoPlayer.repeatMode = MPMovieRepeatModeOne;
        else
            _videoPlayer.repeatMode = MPMovieRepeatModeNone;
        
        [_videoPlayer setContentURL:url];
        [_videoPlayer prepareToPlay];
        [_videoPlayer play];
        [self handleDoubleTap:nil];
        
        return YES;
    }
    
    return NO;
}

- (void)moviePlayerLoadStateDidChange:(NSNotification*)notification
{
    MPMovieLoadState state = [_videoPlayer loadState];
    if(MPMovieLoadStateUnknown == state || MPMovieLoadStateStalled == state)
    {
        //[_maskView.videoIndicator startAnimating];
        //[self.scrollView addSubview:_maskView];
        [self.scrollView addSubview:_playButton];
        
        [self.videoIndicator startAnimating];
        //        [[RCTool frontWindow] addSubview:self.videoIndicator];
    }
    else{
        
        [_maskView.videoIndicator stopAnimating];
        [_maskView removeFromSuperview];
        
        [self.videoIndicator stopAnimating];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    
    if (error) {
        NSLog(@"Video Player did finish with error: %@", error);
        
        //if(-1009 == error.code || -11800 == error.code || -1004 == error.code)
        {
            [RCTool showAlert:@"提示" message:@"视频播放失败，请检查网络连接, 稍后再尝试！"];
        }
    }
    
    if(_maskView)
    {
        //[_maskView.videoIndicator stopAnimating];
        //[self.videoIndicator stopAnimating];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleOneTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"handleOneTap");
    
    if(self.isFullScreen)
    {
        CGRect rect = self.restoreButton.frame;
        if(10 == rect.origin.y)
        {
            self.isHiding = YES;
            self.restoreButton.frame = CGRectMake([RCTool getScreenSize].height - 60,-60, 40, 40);
        }
        else if(-60 == rect.origin.y)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.isHiding = NO;
                self.restoreButton.frame = CGRectMake([RCTool getScreenSize].height - 60,10, 40, 40);
            } completion:^(BOOL finished) {
                self.isHiding = YES;
                [self performSelector:@selector(hideRestoreButton:) withObject:nil afterDelay:3.0];
            }];
        }
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"handleDoubleTap");
    
    //if(MPMoviePlaybackStateStopped != self.videoPlayer.playbackState)
    {
        if(self.isFullScreen)
        {
            [self restoreScreen];
        }
        else
        {
            [self displayFullScreen];
        }
    }
}

- (void)displayFullScreen
{
    self.isFullScreen = YES;
    
    if(_videoPlayer && _maskView.superview == nil)
    {
        _videoPlayer.view.frame = CGRectMake(0, 0, [RCTool getScreenSize].height, [RCTool getScreenSize].width);
        [_videoPlayer.view setCenter:CGPointMake([RCTool getScreenSize].width/2.0, [RCTool getScreenSize].height/2.0)];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [[_videoPlayer view] setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        
        self.restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.restoreButton.frame = CGRectMake([RCTool getScreenSize].height - 60,-60, 40, 40);
        self.restoreButton.tag = 222;
        [self.restoreButton setImage:[UIImage imageNamed:@"restore_button"] forState:UIControlStateNormal];
        [self.restoreButton addTarget:self action:@selector(restoreScreen) forControlEvents:UIControlEventTouchUpInside];
        [_videoPlayer.view addSubview:self.restoreButton];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.isHiding = NO;
            self.restoreButton.frame = CGRectMake([RCTool getScreenSize].height - 60,10, 40, 40);
        } completion:^(BOOL finished) {
            self.isHiding = YES;
            [self performSelector:@selector(hideRestoreButton:) withObject:nil afterDelay:3.0];
        }];
        
        _videoIndicator.center = CGPointMake([RCTool getScreenSize].height/2, [RCTool getScreenSize].width/2);
        [_videoPlayer.view addSubview:_videoIndicator];
        
        [[RCTool frontWindow] addSubview:_videoPlayer.view];
    }
    
}

- (void)hideRestoreButton:(id)agrument
{
    if(NO == self.isHiding)
        return;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.restoreButton.frame = CGRectMake([RCTool getScreenSize].height - 60,-60, 40, 40);
    }];
}

- (void)restoreScreen
{
    self.isFullScreen = NO;
    
    if(_videoPlayer)
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        [[_videoPlayer view] setTransform:CGAffineTransformMakeRotation(0)];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _videoPlayer.view.frame = CGRectMake(0, 0, [RCTool getScreenSize].width, VIDEO_HEIGHT);
        
        UIView* restoreButton = [_videoPlayer.view viewWithTag:222];
        if(restoreButton)
            [restoreButton removeFromSuperview];
        
        [self clickedPlayButton:nil];
        
        [self.scrollView addSubview:_videoPlayer.view];
        [self.scrollView addSubview:self.playButton];
        
        _videoIndicator.center = CGPointMake([RCTool getScreenSize].width/2, VIDEO_HEIGHT/2);
        [_videoIndicator removeFromSuperview];
    }
}

- (void)initButtons
{
    if(nil == _playButton)
    {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(250, VIDEO_HEIGHT - 60, 73.5, 73.5);
        self.playButton.center = CGPointMake([RCTool getScreenSize].width/2.0, VIDEO_HEIGHT/2.0);
        [self.playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(clickedPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_scrollView addSubview:self.playButton];
}

- (void)clickedPlayButton:(id)sender
{
    if(self.isPlaying)
    {
        self.isPlaying = NO;
        
        [self.playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        
        if(_videoPlayer)
        {
            [_videoPlayer pause];
        }
    }
    else
    {
        if([self play])
        {
            [self.videoIndicator startAnimating];
            
            self.isPlaying = YES;
            
            [self.playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Weather

- (void)initWeatherView
{
    if(nil == _weatherView)
    {
        _weatherView = [[RCWeatherView alloc] initWithFrame:CGRectMake(0, VIDEO_HEIGHT, [RCTool getScreenSize].width, WEATHER_HEIGHT)];
    }
    
    [self.weatherView updateContent:self.content];
    
    [self.scrollView addSubview:_weatherView];
}

#pragma mark - Function View

- (void)initFunctionView
{
    if(nil == _functionView)
    {
        _functionView = [[RCFunctionView alloc] initWithFrame:CGRectMake(0, VIDEO_HEIGHT + WEATHER_HEIGHT, [RCTool getScreenSize].width, FUNCTION_HEIGHT)];
        _functionView.delegate = self;
    }
    
    
    [self.scrollView addSubview:_functionView];
}

- (void)clickedFunction:(int)index
{
    NSLog(@"clickedFunction:%d",index);
    
    if(self.isPlaying)
        [self clickedPlayButton:nil];
    
    if(0 == index)
    {
        RCJianJieViewController* temp = [[RCJianJieViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content token:self.item];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(1 == index)
    {
        [self daohang:nil];
    }
    else if(3 == index)
    {
        RCJiuDianViewController* temp = [[RCJiuDianViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(4 == index)
    {
        RCMeiShiViewController* temp = [[RCMeiShiViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(2 == index)
    {
        RCYuLeViewController* temp = [[RCYuLeViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(5 == index)
    {
        RCXiangCeViewController* temp = [[RCXiangCeViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(6 == index)
    {
        [self clickedFavButton:nil];
    }
    else if(7 == index)
    {
        [self clickedShareButton:nil];
    }
}

#pragma mark - Toolbar

- (void)initToolbar
{
    if(nil == _toolbar)
    {
        CGFloat offset_y = [RCTool getScreenSize].height - 44;
        if([RCTool systemVersion] < 7.0)
            offset_y -= NAVIGATION_BAR_HEIGHT;
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, offset_y, [RCTool getScreenSize].width, 44)];
        _toolbar.alpha = 0.7;
        
        UIBarButtonItem* fixedSpaceItem0 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                          target:nil
                                                                                          action:nil] autorelease];
        fixedSpaceItem0.width = 46;
        
        _shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedShareButton:)];
        
        UIBarButtonItem* fixedSpaceItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                          target:nil
                                                                                          action:nil] autorelease];
        fixedSpaceItem1.width = 140;
        
        NSString* imageName = @"btn_fav";
        if(self.isFaved)
            imageName = @"btn_select_fav";
        
        self.favItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(clickedFavButton:)] autorelease];
        
        [_toolbar setItems:[NSArray arrayWithObjects:fixedSpaceItem0,_shareItem,fixedSpaceItem1,self.favItem,nil] animated:YES];
    }
    
    [self.view addSubview:_toolbar];
}

- (void)updateFavBarItem
{
    
    UIBarButtonItem* fixedSpaceItem0 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil] autorelease];
    fixedSpaceItem0.width = 46;
    
    if(nil == _shareItem)
    {
        _shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedShareButton:)];
    }
    
    UIBarButtonItem* fixedSpaceItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil] autorelease];
    fixedSpaceItem1.width = 140;
    
    NSString* imageName = @"btn_fav";
    if(self.isFaved)
        imageName = @"btn_select_fav";
    
    self.favItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(clickedFavButton:)] autorelease];
    
    [_toolbar setItems:[NSArray arrayWithObjects:fixedSpaceItem0,_shareItem,fixedSpaceItem1,self.favItem,nil] animated:YES];
}

- (void)clickedShareButton:(id)sender
{
    //    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作"
    //                                                              delegate:self
    //                                                     cancelButtonTitle:@"取消"
    //                                                destructiveButtonTitle:nil
    //                                                     otherButtonTitles:@"新浪微博分享",@"腾讯微博分享",nil];
    //    actionSheet.tag = SHARE_TAG;
    //    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //    [actionSheet showFromToolbar:self.toolbar];
    //    [actionSheet release];
    
    [UIView animateWithDuration:0.3 animations:^{
        if(self.shareView)
        {
            CGRect rect = self.shareView.frame;
            rect.origin.y = [RCTool getScreenSize].height - 216;
            self.shareView.frame = rect;
        }
    }];
}

- (IBAction)clickedCancelShareButton:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        if(self.shareView)
        {
            CGRect rect = self.shareView.frame;
            rect.origin.y = [RCTool getScreenSize].height;
            self.shareView.frame = rect;
        }
    }];
}

- (IBAction)clickedShareToSinaButton:(id)sender
{
    NSLog(@"clickedShareToSinaButton");
    [self clickedCancelShareButton:nil];
    
    ShareEntity* entity = [[[ShareEntity alloc] init] autorelease];
    
    NSString* jd_name = [self.item objectForKey:@"jd_name"];
    if(0 == [jd_name length])
        jd_name = [self.content objectForKey:@"jd_name"];
    
    if(0 == [jd_name length])
        jd_name = @"爱城市";
    else
        jd_name = [NSString stringWithFormat:@"爱城市--%@",jd_name];
    entity.shareTitle = jd_name;
    entity.shareContent = SHARE_CONTENT;
    entity.shareUrl = SHARE_LINK;
    //entity.shareImgURL = @"http://www.baidu.com";
    
    [iCitySDK shareCitySDK].delegate = self;
    [[iCitySDK shareCitySDK] showShareInView:self.view WithEntity:entity WithFinishSEL:@selector(shareToFinished:)];
}

- (IBAction)clickedShareToQQButton:(id)sender
{
    NSLog(@"clickedShareToQQButton");
    [self clickedCancelShareButton:nil];
    
    ShareEntity* entity = [[[ShareEntity alloc] init] autorelease];

    NSString* jd_name = [self.item objectForKey:@"jd_name"];
    if(0 == [jd_name length])
        jd_name = [self.content objectForKey:@"jd_name"];
    
    if(0 == [jd_name length])
        jd_name = @"爱城市";
    else
        jd_name = [NSString stringWithFormat:@"爱城市--%@",jd_name];
    entity.shareTitle = jd_name;
    entity.shareContent = SHARE_CONTENT;
    entity.shareUrl = SHARE_LINK;
    //entity.shareImgURL = @"http://www.baidu.com";
    
    [iCitySDK shareCitySDK].delegate = self;
    [[iCitySDK shareCitySDK] showShareInView:self.view WithEntity:entity WithFinishSEL:@selector(shareToFinished:)];
}

- (void)shareToFinished:(NSString*)token
{
    if(1 == [token intValue])
        [RCTool showAlert:@"提示" message:@"分享成功!"];
    else
        [RCTool showAlert:@"提示" message:@"对不起，分享失败!"];
}

- (void)clickedFavButton:(id)sender
{
    NSString* action = @"";
    if(self.isFaved)
    {
        action = @"delsc";
    }
    else{
        
        action = @"addsc";
    }
    
    NSString* jd_id = @"";
    if(self.item)
        jd_id = [self.item objectForKey:@"jd_id"];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=%@&token=%@&jd_id=%@",BASE_URL,action,[RCTool getDeviceID],jd_id];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    [temp request:urlString delegate:self resultSelector:@selector(finishedFavRequest:) token:nil];
}

- (void)finishedFavRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        if([RCTool hasNoError:result])
        {
            self.isFaved = self.isFaved?NO:YES;
            
            if(self.isFaved)
                [[iToast makeText:@"添加收藏成功!"] show];
            else
                [[iToast makeText:@"取消收藏成功!"] show];
            
            [self updateFavBarItem];
        }
    }
}

/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(SHARE_TAG == actionSheet.tag)
    {
        if(1 == buttonIndex)
        {
            [self shareText:[RCTool getShareText] type:SHT_QQ];
        }
        else if(0 == buttonIndex)
        {
            [self shareText:[RCTool getShareText] type:SHT_SINA];
        }
    }
}

- (void)shareText:(NSString*)text type:(SHARE_TYPE)type
{
    if(SHT_QQ == type)
    {
        SLComposeViewController* slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTencentWeibo];
        
        [slComposerSheet setInitialText:text];
        
        UIImage* image = nil;
        if(self.item)
        {
            NSString* imageUrl = [self.item objectForKey:@"jd_title_pic"];
            if([imageUrl length])
            {
                image = [RCTool getImageFromLocal:imageUrl];
            }
        }
        if(image)
            [slComposerSheet addImage:image];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            if (result != SLComposeViewControllerResultCancelled)
            {
                [RCTool showAlert:@"提示" message:@"成功分享到腾讯微博！"];
            }
        }];
        
    }
    else if(SHT_SINA == type)
    {
        SLComposeViewController* slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        [slComposerSheet setInitialText:text];
        UIImage* image = nil;
        if(self.item)
        {
            NSString* imageUrl = [self.item objectForKey:@"jd_title_pic"];
            if([imageUrl length])
            {
                image = [RCTool getImageFromLocal:imageUrl];
            }
        }
        if(image)
            [slComposerSheet addImage:image];
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            if (result != SLComposeViewControllerResultCancelled)
            {
                [RCTool showAlert:@"提示" message:@"成功分享到新浪微博！"];
            }
        }];
    }
}

- (IBAction)clickedSinaButton:(id)sender
{
    [self clickedCancelShareButton:nil];
    [self shareText:[RCTool getShareText] type:SHT_SINA];
}

- (IBAction)clickedQQButton:(id)sender
{
    [self clickedCancelShareButton:nil];
    [self shareText:[RCTool getShareText] type:SHT_QQ];
}
*/

- (IBAction)daohang:(id)sender
{
    
    NSString* jd_gps = [self.item objectForKey:@"jd_gps"];
    if(0 == [jd_gps length])
        jd_gps = [self.content objectForKey:@"jd_gps"];
    
    if(0 == [jd_gps length])
        return;
    
    NSArray* array = @[@{@"gps":jd_gps}];
    RCRouteMapViewController* temp = [[RCRouteMapViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:array title:@"路径规划"];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
 
/*
    //节点数组
    NSMutableArray *nodesArray = [[[NSMutableArray alloc]    initWithCapacity:2] autorelease];
    
    //起点
    BNRoutePlanNode *startNode = [[[BNRoutePlanNode alloc] init] autorelease];

    BMKMapPoint mapPoint = {[RCTool getUserLocation].longitude,[RCTool getUserLocation].latitude};
    
    //（2）定义输出参数
    BNPosition* naviPos =  [[[BNPosition alloc]init] autorelease];
    
    
    //(3)进行转换
    BOOL ret = [BNTools ConvertBaiduMapPoint:&mapPoint ToBaiduNaviPoint:naviPos];
    
    //（4）使用转换后得到的导航坐标
    if(ret)
    {
        NSLog( @"地图坐标转换成导航坐标成功，navipos:(%f,%f)",naviPos.x,naviPos.y);
    }
    else
    {
        NSLog(@" 转换失败");
    }

    startNode.pos = naviPos;
    [nodesArray addObject:startNode];
    
    //终点
    NSString* jd_gps = [self.item objectForKey:@"jd_gps"];
    if(0 == [jd_gps length])
        jd_gps = [self.content objectForKey:@"jd_gps"];
    
    if(0 == [jd_gps length])
        return;

    NSArray* array = [jd_gps componentsSeparatedByString:@","];
    if(2 == [array count])
    {
        BNRoutePlanNode *endNode = [[[BNRoutePlanNode alloc] init] autorelease];
        
        BMKMapPoint mapPoint = {[[array objectAtIndex:0] floatValue],[[array objectAtIndex:1] floatValue]};
        
        //（2）定义输出参数
        BNPosition* naviPos =  [[[BNPosition alloc]init] autorelease];
        
        //(3)进行转换
        BOOL ret = [BNTools ConvertBaiduMapPoint:&mapPoint ToBaiduNaviPoint:naviPos];
        
        //（4）使用转换后得到的导航坐标
        if(ret)
        {
            NSLog( @"地图坐标转换成导航坐标成功，navipos:(%f,%f)",naviPos.x,naviPos.y);
        }
        else
        {
            NSLog(@" 转换失败");
        }
        
        endNode.pos = naviPos;
        [nodesArray addObject:endNode];
        
    }
    
    //发起路径规划
    if(2 == [nodesArray count])
    {
        [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
    }
    
//    //初始化调启导航时的参数管理类
//    NaviPara* para = [[[NaviPara alloc]init] autorelease];
//    //指定导航类型
//    para.naviType = NAVI_TYPE_WEB;
//    
//    //初始化起点节点
//    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
//    //指定起点经纬度
//    start.pt = [RCTool getUserLocation];
//    //指定起点名称
//    start.name = @"起点";
//    //指定起点
//    para.startPoint = start;
//    
//    //初始化终点节点
//    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
//    //指定终点经纬度
//    NSString* jd_gps = [self.item objectForKey:@"jd_gps"];
//    if(0 == [jd_gps length])
//        return;
//    
//    NSArray* array = [jd_gps componentsSeparatedByString:@","];
//    if(2 == [array count])
//    {
//        CLLocationCoordinate2D coor;
//        coor.latitude = [[array objectAtIndex:1] floatValue];
//        coor.longitude = [[array objectAtIndex:0] floatValue];
//        end.pt = coor;
//        //指定终点名称
//        end.name = @"终点";
//        //指定终点
//        para.endPoint = end;
//        
//        //指定返回自定义scheme
//        //para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
//        
//        //调启百度地图客户端导航
//        [BMKNavigation openBaiduMapNavigation:para];
//    }
*/
}

/*
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    [BNCoreServices_Sound stopTTSPlayer];
}

- (void)routePlanDidUserCanceled:(NSDictionary*)userInfo
{
    NSLog(@"routePlanDidUserCanceled");
    
    [BNCoreServices_Sound stopTTSPlayer];
}

*/

@end
