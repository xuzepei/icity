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
    return;
    
    if(nil == _imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width,160)];
        [self.view addSubview:_imageView];
    }

    
    if(nil == self.textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 228, 310, [RCTool getScreenSize].height - 228)];
    }
    
    [self.view addSubview:self.textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = 12.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSString* content = [self.item objectForKey:@"jd_desc"];
    if(0 == [content length])
        content = @"";
    else{
        if([content hasPrefix:@"  "])
        {
            NSRange range = [content rangeOfString:@"  "];
            content = [content substringFromIndex:range.location + range.length];
        }
        else if([content hasPrefix:@"  "])
        {
            NSRange range = [content rangeOfString:@"  "];
            if(range.location != NSNotFound)
            {
                content = [content substringFromIndex:range.location + range.length];
            }
        }
  
        content = [NSString stringWithFormat:@"       %@",content];
    }
    
//    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
//    _textView.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.text = content;
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
    UIImage* image = [RCTool getImageFromLocal:imageUrl];
    if(image)
        self.imageView.image = image;
    
    [self initToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item token:(NSDictionary*)token
{
    self.item = item;
    
    self.title = [self.item objectForKey:@"jd_name"];
    
    self.textView.text = [self.item objectForKey:@"jd_desc"];
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
    UIImage* image = [RCTool getImageFromLocal:imageUrl];
    if(image)
        self.imageView.image = image;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:imageUrl
                                         delegate:self
                                            token:nil];
    }
    
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
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height - 44, [RCTool getScreenSize].width, 44)];
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
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"新浪微博分享",@"腾讯微博分享",nil];
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

#pragma mark - Web View

- (void)initWebView
{
    if(nil == _webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - NAVIGATION_BAR_HEIGHT)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        
        //隐藏UIWebView shadow
        [RCTool hidenWebViewShadow:_webView];
        
    }
    
    [self.view addSubview: _webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	return NO;
}

@end
