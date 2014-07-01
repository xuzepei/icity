//
//  RCJianJieViewController.m
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJianJieViewController.h"
#import "RCImageLoader.h"
#import "RCHttpRequest.h"


#define SHARE_TAG 112

@interface RCJianJieViewController ()

@end

@implementation RCJianJieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake([RCTool getScreenSize].width/2.0, [RCTool getScreenSize].height/2.0);
        [self.view addSubview:_indicator];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.imageView = nil;
    self.textView = nil;
    self.image = nil;
    self.webView.delegate = nil;
    self.webView = nil;
    self.indicator = nil;
    self.token = nil;
    
    self.shareView = nil;
    self.cancelShareButton = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initWebView];
    [self initToolbar];
    
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

- (void)updateContent:(NSDictionary*)item token:(NSDictionary*)token
{
    self.item = item;
    self.token = token;
    self.title = [self.item objectForKey:@"jd_name"];
    
    [self loadWebPage];
    
    //http://acs.akange.com:81/index.php?c=main&a=travel&jd_id=3&token=renykang
    

    
//    self.textView.text = [self.item objectForKey:@"jd_desc"];
//    
//    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
//    UIImage* image = [RCTool getImageFromLocal:imageUrl];
//    if(image)
//        self.imageView.image = image;
//    else
//    {
//        [[RCImageLoader sharedInstance] saveImage:imageUrl
//                                         delegate:self
//                                            token:nil];
//    }
    
    NSString* jd_id = @"";
    if(token)
        jd_id = [token objectForKey:@"jd_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jdinfo&jd_id=%@&token=%@",BASE_URL,jd_id,[RCTool getDeviceID]];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:nil];
    if(b)
    {
        //self.isLoading = YES;
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
//    self.isLoading = NO;
//    [RCTool hideIndicator];
    
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
                    NSString* scflag = [data objectForKey:@"scflag"];
                    if([scflag isEqualToString:@"1"])
                        self.isFaved = YES;
                
                [self updateFavBarItem];
            }
        }
    }
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
	if([urlString isEqualToString:imageUrl])
	{
		self.imageView.image = [RCTool getImageFromLocal:imageUrl];
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

#pragma mark - Share View

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

    [self.view bringSubviewToFront:self.shareView];
    [UIView animateWithDuration:0.3 animations:^{
        if(self.shareView)
        {
            CGRect rect = self.shareView.frame;
            if([RCTool systemVersion] >= 7.0)
                rect.origin.y = [RCTool getScreenSize].height - 216;
            else
                rect.origin.y = [RCTool getScreenSize].height - 216 - NAVIGATION_BAR_HEIGHT;
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

#pragma mark - Web View

- (void)initWebView
{
    if(nil == _webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - 44)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        
        //隐藏UIWebView shadow
        [RCTool hidenWebViewShadow:_webView];
        
    }
    
    [self.view addSubview: _webView];
    
    [self loadWebPage];
}

- (void)loadWebPage
{
    NSString* jd_id = @"";
    if(self.item)
    {
        jd_id = [self.item objectForKey:@"jd_id"];
        NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=travel&jd_id=%@&token=%@",BASE_URL,jd_id,[RCTool getDeviceID]];
        if(self.webView)
        {
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [self.webView loadRequest:request];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    //NSString* url = [request.URL absoluteString];
    //NSLog(@"url:%@",url);
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_indicator stopAnimating];
    
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[_indicator stopAnimating];
}

@end
