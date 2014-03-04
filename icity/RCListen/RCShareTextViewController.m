//
//  RCShareTextViewController.m
//  RCFang
//
//  Created by xuzepei on 5/27/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCShareTextViewController.h"
#import "RCTool.h"
#import "RCShareTextToolbar.h"
#import "CUShareCenter.h"

@interface RCShareTextViewController ()

@end


#define TEXT_VIEW_HEIGHT 200.0
#define TOOLBAR_HEIGHT 33.0f

@implementation RCShareTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(clickedRightBarButtonItem:)] autorelease];
        self.navigationItem.rightBarButtonItem = item;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        item = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarButtonItem:)] autorelease];
        self.navigationItem.leftBarButtonItem = item;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.textView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initTextView];
    [self initToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)clickedRightBarButtonItem:(id)sender
{
    int count = [_textView.text length];
    if(count > 0 && count <= 140)
    {
        if(SHT_SINA == _shareType)
        {
            CUShareCenter* sinaShare = [CUShareCenter sharedInstanceWithType:CUSHARE_SINA];
            
            if ([sinaShare isBind])
            {
                [sinaShare sendWithText:_textView.text delegate:self];
            }
        }
        else if(SHT_QQ == _shareType)
        {
            CUShareCenter* qqShare = [CUShareCenter sharedInstanceWithType:CUSHARE_QQ];
            
            if([qqShare isBind])
            {
                [qqShare sendWithText:_textView.text delegate:self];
            }
        }
    }

}

- (void)sendTextSucceeded:(id)token
{
    NSLog(@"sendTextSucceeded");
    
    [self dismissModalViewControllerAnimated:YES];
    
    [RCTool showAlert:@"提示" message:@"分享成功!"];
}

- (void)sendTextFailed:(id)token
{
    NSLog(@"sendTextFailed");
    
    [RCTool showAlert:@"提示" message:@"分享失败！"];
}

- (void)initTextView
{
    if(nil == _textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, TEXT_VIEW_HEIGHT)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
    }
    
    _textView.text = SHARE_TEXT;
    [self textViewDidChange:nil];
    
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    int count = [_textView.text length];
    if(count > 0 && count <= 140)
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

    if(_toolbar)
        [_toolbar updateTextCount:count];
}

- (void)initToolbar
{
    if(nil == _toolbar)
    {
        _toolbar = [[RCShareTextToolbar alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, TOOLBAR_HEIGHT)];
        _toolbar.delegate = self;
    }
    
    if(_textView)
    {
        _textView.inputAccessoryView = _toolbar;
    }
}

- (void)clickedClearButton:(id)token
{
    _textView.text = nil;
    [self textViewDidChange:nil];
}

- (void)updateContent:(SHARE_TYPE)shareType text:(NSString*)text
{
    self.shareType = shareType;
    
    if(SHT_SINA == shareType)
    {
        self.title = @"分享到新浪微博";
    }
    else if(SHT_QQ == shareType)
    {
        self.title = @"分享到腾讯微博";
    }
    
    [self initTextView];
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow: (NSNotification*)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	
	[UIView beginAnimations:@"keyboardWillShow" context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = _textView.frame;
	rect.size.height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT  - keyboardRect.size.height - TOOLBAR_HEIGHT;
	_textView.frame = rect;

	[UIView commitAnimations];
	
}

- (void)keyboardWillHide: (NSNotification*)notification
{
}

@end
