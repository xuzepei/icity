//
//  RCWebViewController.m
//  RCFang
//
//  Created by xuzepei on 4/4/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCWebViewController.h"
#import "RCTool.h"

@interface RCWebViewController ()

@end

@implementation RCWebViewController

- (id)init:(BOOL)hideToolbar
{
    self.hideToolbar = hideToolbar;
    
    return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clickRightBarButtonItem:)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//        [rightBarButtonItem release];
        
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0];
        //titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = NAVIGATION_BAR_TITLE_COLOR;
        titleLabel.text = @"网址";
        self.navigationItem.titleView = titleLabel;
        [titleLabel sizeToFit];
        
        [self initWebView];
        
    }
    return self;
}

- (void)dealloc
{
    self.urlString = nil;
    
    if(self.webView)
        self.webView.delegate = nil;
    self.webView = nil;
    
    self.indicator = nil;
    self.toolbar = nil;
    self.backwardItem = nil;
    self.forwardItem = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0, 52, 33);
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui_on"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickedLeftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [self initWebView];
    
    if(NO == self.hideToolbar)
        [self initToolbar];
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if(self.webView)
        self.webView.delegate = nil;
    self.webView = nil;
    
    self.indicator = nil;
    self.toolbar = nil;
    self.backwardItem = nil;
    self.forwardItem = nil;
}

- (void)clickRightBarButtonItem:(id)sender
{
    [self clickRefreshItem:nil];
}

- (void)updateContent:(NSString *)urlString title:(NSString*)title
{
    if(0 == [urlString length])
        return;
    
    self.urlString = urlString;
    
    UILabel* titleLabel = (UILabel*)self.navigationItem.titleView;
    
    if([title length])
        titleLabel.text = title;
    else
        titleLabel.text = _urlString;
    
    [self updateToolbarItem];
    
    if(_webView)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
        [_webView loadRequest:request];
    }
    
}

#pragma mark - Toolbar

- (void)initToolbar
{
    if (nil == _toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT*2,[RCTool getScreenSize].width,NAVIGATION_BAR_HEIGHT)];
        
        _toolbar.barStyle = UIBarStyleBlack;
        
        UIBarButtonItem* fixedSpaceItem0 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                          target:nil
                                                                                          action:nil] autorelease];
        fixedSpaceItem0.width = 180;
        
        UIBarButtonItem* fixedSpaceItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                          target:nil
                                                                                          action:nil] autorelease];
        fixedSpaceItem1.width = 50;
        
        
        UIBarButtonItem* refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                     target:self
                                                                                     action:@selector(clickRefreshItem:)];
        
        self.backwardItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browse_backward"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(clickBackwardItem:)] autorelease];
        _backwardItem.enabled = NO;
        
        self.forwardItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browse_forward"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(clickForwardItem:)] autorelease];
        
        _forwardItem.enabled = NO;
        
        [_toolbar setItems:[NSArray arrayWithObjects: /*refreshItem,*/fixedSpaceItem0,_backwardItem,fixedSpaceItem1,_forwardItem,nil]
                  animated: NO];
        
        [refreshItem release];
    }
	
	[self.view addSubview:_toolbar];

}

- (void)updateToolbarItem
{
	_backwardItem.enabled = _webView.canGoBack? YES:NO;
	_forwardItem.enabled = _webView.canGoForward? YES:NO;
}

- (void)clickRefreshItem:(id)sender
{
    if(_webView)
        [_webView reload];
}

- (void)clickBackwardItem:(id)sender
{
    if(_webView)
        [_webView goBack];
	
}

- (void)clickForwardItem:(id)sender
{
    if(_webView)
        [_webView goForward];
}

#pragma mark - WebView

- (void)initWebView
{
    if (nil == _webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT*2)];
        _webView.delegate = self;
        //_webView.scalesPageToFit = YES;
    }
    
    CGFloat height = NAVIGATION_BAR_HEIGHT*2;
    if(self.hideToolbar)
        height = NAVIGATION_BAR_HEIGHT;
    _webView.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - height);
    
    [self.view addSubview: _webView];
    
    if (nil == _indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(160, 200 - 44);
    }
    
    [_webView addSubview: _indicator];
}



#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	if(request)
	{
//        if(self.hideToolbar)
//            return YES;
//        
//		NSURL* url = [request URL];
//		NSString* urlString = [url absoluteString];
//        if(NO == [urlString isEqualToString:_urlString])
//            self.title = urlString;
	}
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_indicator stopAnimating];
	
	[self updateToolbarItem];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[_indicator stopAnimating];
}


@end
