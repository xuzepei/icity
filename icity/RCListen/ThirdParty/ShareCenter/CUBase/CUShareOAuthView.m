//
//  CUShareOAuthView.m
//  ShareCenterExample
//
//  Created by curer yg on 12-3-13.
//  Copyright (c) 2012年 zhubu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CUShareOAuthView.h"
#import "CUConfig.h"
#import "RCTool.h"

int kActiveIndicatorTag = 10;

CGRect ApplicationFrame(UIInterfaceOrientation interfaceOrientation) {
	
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
    
	bounds.origin.x = 0;
	return bounds;
}

@interface  CUShareOAuthView()

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (UIInterfaceOrientation)currentOrientation;
- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

@end

@implementation CUShareOAuthView

@synthesize webView;
@synthesize loginRequest;


#pragma mark -  life

- (id)init
{
    if (self = [super init]) {

    }
    
    return self;
}

- (void)dealloc
{
    self.webView = nil;
    self.loginRequest = nil;
    
    [panelView release], panelView = nil;
    [containerView release], containerView = nil;
    [webView release], webView = nil;
    [indicatorView release], indicatorView = nil;
    
    self.titleBar = nil;
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    self.titleBar.topItem.title = title;
}

#pragma mark -  UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    self.view.frame = CGRectMake(0, 20, winSize.width, winSize.height-20);
    // background settings
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.view.autoresizesSubviews = NO;
    
//    // add the panel view
//    panelView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 440)];
//    [panelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
//    [[panelView layer] setMasksToBounds:NO]; // very important
//    [[panelView layer] setCornerRadius:10.0];
//    [self.view addSubview:panelView];
//    
//    // add the conainer view
//    containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 420)];
//    [[containerView layer] setBorderColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.7].CGColor];
//    [[containerView layer] setBorderWidth:1.0];
//    
//
    //add title bar
    [self initTitleView];
    
    // add the web view
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
//
//    [panelView addSubview:containerView];
//    
//    // add the buttons & labels
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setShowsTouchWhenHighlighted:YES];
//    [closeButton setFrame:CGRectMake(275, -5, 30, 30)];
//    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    //[closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
//    //[closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
//    [closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [panelView addSubview:closeButton];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:indicatorView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown 
    || toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Title View

- (void)initTitleView
{
    if(nil == _titleBar)
    {
        _titleBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, NAVIGATION_BAR_HEIGHT)];
        
        UINavigationItem *navigationItem = [[[UINavigationItem alloc] initWithTitle:@""] autorelease];
        navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButtonTouched:)] autorelease];
        
        [_titleBar pushNavigationItem:navigationItem animated: NO];
    }
    
    [self.view addSubview:_titleBar];
}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(authViewDidCancel:)])
    {
        [_delegate authViewDidCancel:self];
    }
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
{
    [self.view setTransform:CGAffineTransformIdentity];
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        [self.view setFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
//        [panelView setFrame:CGRectMake(10, 30, winSize.width-20, winSize.height - 40)];
//        [containerView setFrame:CGRectMake(10, 10, winSize.width-20, winSize.height-60)];
//        [webView setFrame:CGRectMake(0, 0, winSize.width-40, winSize.height-60)];
//        [indicatorView setCenter:CGPointMake(winSize.width/2, winSize.height/2)];
//    }
//    else
//    {
//        [self.view setFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
//        [panelView setFrame:CGRectMake(10, 30, winSize.width-20, winSize.height-40)];
//        [containerView setFrame:CGRectMake(10, 10, winSize.width-40, winSize.height-60)];
//        [webView setFrame:CGRectMake(0, 0, winSize.width-40, winSize.height-60)];
//        [indicatorView setCenter:CGPointMake(winSize.width/2, winSize.height/2)];
//    }
    
    self.view.center = CGPointMake(winSize.width/2, winSize.height/2 + 10);
    
    [self.view setTransform:[self transformForOrientation:orientation]];
    
    previousOrientation = orientation;
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    // nothing shall be done here
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
    [self removeObservers];
	[self.view removeFromSuperview];
}

#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}

- (UIActivityIndicatorView *)getActivityIndicatorView
{
    return indicatorView;
}

- (void)show:(BOOL)animated
{
    [self sizeToFitOrientation:[self currentOrientation]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
    
  	[window addSubview:self.view];
    
    if (animated)
    {
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        [self.view.superview.layer addAnimation:animation
                                         forKey:@"push_oauth"];
        
//        [panelView setAlpha:0];
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.2];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
//        [panelView setAlpha:0.5];
//        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
//        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
    
    [self addObservers];
}

- (void)hide:(BOOL)animated
{
	if (animated)
    {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [self.view.superview.layer addAnimation:animation
                                         forKey:@"pull_oauth"];
        
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationDuration:0.3];
//		[UIView setAnimationDelegate:self];
//		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
//		[self.view setAlpha:0];
//		[UIView commitAnimations];
	}
    [self hideAndCleanUp];
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
	}
}


@end
