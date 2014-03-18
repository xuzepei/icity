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
#import "CUShareCenter.h"
#import "iToast.h"

#define VIDEO_HEIGHT 180.0f
#define WEATHER_HEIGHT 52.0f
#define FUNCTION_HEIGHT 540/2.0f

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
            _videoIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _videoIndicator.hidesWhenStopped = YES;
            _videoIndicator.center = CGPointMake(160, 120);
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    self.title = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initVideoPlayer];
    
    [self initWeatherView];
    
    [self initFunctionView];
    
    [self.scrollView setContentSize:CGSizeMake([RCTool getScreenSize].width, 588)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self initToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.title = [self.item objectForKey:@"jd_name"];
    
    NSString* jd_id = @"";
    if(self.item)
        jd_id = [self.item objectForKey:@"jd_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jdinfo&jd_id=%@&token=%@",BASE_URL,jd_id,[RCTool getDeviceID]];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    [temp request:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:nil];
}

- (void)finishedContentRequest:(NSString*)jsonString
{
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
                }
                
                [self updateFavBarItem];
            }
        }
        
        if(self.weatherView)
            [self.weatherView updateContent:self.content];
    }
}


#pragma mark - Video Player

- (void)initVideoPlayer
{
    if(nil == _videoPlayer)
    {
        _videoPlayer =
        [[MPMoviePlayerController alloc]
         initWithContentURL:[NSURL URLWithString:VIDEO_LIVE_URL]];
        
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
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_videoPlayer.view addGestureRecognizer:doubleTap];
        [doubleTap release];
    }
    
    _videoPlayer.view.frame = CGRectMake(0, 0, [RCTool getScreenSize].width, VIDEO_HEIGHT);
    
    [self.scrollView addSubview:_videoPlayer.view];
    
    [_videoPlayer prepareToPlay];
    [_videoPlayer play];
}

- (void)moviePlayerLoadStateDidChange:(NSNotification*)notification
{
    MPMovieLoadState state = [_videoPlayer loadState];
    if(MPMovieLoadStateUnknown == state || MPMovieLoadStateStalled == state)
    {
        [self.videoIndicator startAnimating];
    }
    else{
        [self.videoIndicator stopAnimating];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    
    if (error) {
        NSLog(@"Video Player did finish with error: %@", error);
        
        if(-1009 == error.code)
        {
            [RCTool showAlert:@"提示" message:@"视频播放失败，请检查网络连接！"];
        }
    }
    
    [self.videoIndicator stopAnimating];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"handleDoubleTap");
    
//    if(NO == self.playAudio &&  MPMoviePlaybackStateStopped != self.videoPlayer.playbackState)
//    {
//        if(nil == _videoMask.superview)
//        {
//            [self restoreScreen];
//        }
//    }
}

- (void)displayFullScreen
{
//    if(_videoMask.superview)
//    {
//        if(_videoPlayer)
//        {
//            if(_videoMask)
//                [_videoMask removeFromSuperview];
//            
//            if(_expandingButtonBar)
//                _expandingButtonBar.hidden = YES;
//            
//            if(_inputBar)
//                _inputBar.hidden = YES;
//            
//            _videoPlayer.view.frame = CGRectMake(0, 0, [WRTool getScreenSize].height, [WRTool getScreenSize].width);
//            [_videoPlayer.view setCenter:CGPointMake([WRTool getScreenSize].width/2.0, [WRTool getScreenSize].height/2.0)];
//            
//            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
//            
//            [self hideFloatView:YES];
//            
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
//            [[_videoPlayer view] setTransform:CGAffineTransformMakeRotation(M_PI/2)];
//            
//        }
//    }
    
}

- (void)restoreScreen
{
//    if(_videoPlayer)
//    {
//        //[[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
//        [[_videoPlayer view] setTransform:CGAffineTransformMakeRotation(0)];
//        _videoPlayer.view.frame = CGRectMake(0, 0, [WRTool getScreenSize].width, VIDEO_PLAYER_HEIGHT);
//        [self.view addSubview:_videoPlayer.view];
//        
//        if(_videoMask)
//        {
//            [self.view addSubview: _videoMask];
//        }
//        
//        [self initFloatView];
//        
//        if(_expandingButtonBar && [WRTool openAll2])
//            _expandingButtonBar.hidden = NO;
//        
//        if(_inputBar)
//            _inputBar.hidden = NO;
//    }
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
    
    if(0 == index)
    {
        RCJianJieViewController* temp = [[RCJianJieViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(1 == index)
    {
        RCJiuDianViewController* temp = [[RCJiuDianViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(2 == index)
    {
        RCMeiShiViewController* temp = [[RCMeiShiViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(3 == index)
    {
        RCYuLeViewController* temp = [[RCYuLeViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(4 == index)
    {
        RCXiangCeViewController* temp = [[RCXiangCeViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:self.content];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
}

#pragma mark - Toolbar

- (void)initToolbar
{
    if(nil == _toolbar)
    {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height - 44, [RCTool getScreenSize].width, 44)];
        
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
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"通过新浪微博分享",@"通过腾讯微博分享",nil];
    actionSheet.tag = SHARE_TAG;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromToolbar:self.toolbar];
    [actionSheet release];
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

@end
