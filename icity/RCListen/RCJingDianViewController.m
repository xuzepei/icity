//
//  RCJingDianViewController.m
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJingDianViewController.h"
#import "RCHttpRequest.h"

#define VIDEO_HEIGHT 180.0f
#define WEATHER_HEIGHT 52.0f
#define FUNCTION_HEIGHT 540/2.0f

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
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //[self initVideoPlayer];
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
}

@end
