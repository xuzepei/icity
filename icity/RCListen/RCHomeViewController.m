//
//  RCHomeViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCHomeViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"

#define AD_FRAME_HEIGHT 120.0

@interface RCHomeViewController ()

@end

@implementation RCHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0];
        //titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = NAVIGATION_BAR_TITLE_COLOR;
        self.navigationItem.titleView = titleLabel;
        titleLabel.text = @"风行车管家";
        [titleLabel sizeToFit];
        
    }
    return self;
}

- (void)dealloc
{
    self.adScrollView = nil;
    self.tableView = nil;
    self.item = nil;


    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self updateRightButton];
//    
//    [self updateContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
//    [self updateAd];
//    
//    [self initButtons];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.adScrollView = nil;
    self.tableView = nil;
}

- (void)updateRightButton
{
    NSString* imageName = [RCTool isLogin]?@"dengl_2":@"dengl_1";
    NSString* imageName2 = [RCTool isLogin]?@"dengl_2_on":@"dengl_1_on";
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0, 64, 33);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName2] forState:UIControlStateHighlighted];
    
    SEL selector = [RCTool isLogin]?@selector(clickedPersonCenterButton:):@selector(clickedLoginButton:);
    
    //selector = @selector(clickedLoginButton:);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


#pragma mark - AdScrollView

- (void)initAdScrollView
{
    self.adHeight = 0;
    
    NSDictionary* ad = [RCTool getAdByType:@"index"];
    if(ad)
    {
        //NSString* show = [ad objectForKey:@"show"];
        //if([show isEqualToString:@"1"])
        {
            NSArray* urlArray = [ad objectForKey:@"list"];
            if(urlArray && [urlArray isKindOfClass:[NSArray class]])
            {
                if([urlArray count])
                {
                    if(nil == _adScrollView)
                    {
                        self.adHeight = AD_FRAME_HEIGHT;
                        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
                        _adScrollView.delegate = self;
                    }
                    
                    [_adScrollView updateContent:urlArray];
                    
                    [self.view addSubview: _adScrollView];
                }
            }
        }
    }
}

- (void)updateAd
{
    NSString* urlString = [NSString stringWithFormat:@"%@/index_ad.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];

    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setAd:@"index" ad:result];
        
        [self initAdScrollView];
        
        if(_tableView)
        {
            _tableView.frame = CGRectMake(0,self.adHeight,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.adHeight - TAB_BAR_HEIGHT - 40);
        }
    }
}

- (void)updateContent
{
    NSString* username = [RCTool getUsername];
    
    NSString* token = [NSString stringWithFormat:@"username=%@",username];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/index_api.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedTextRequest:) token:token];
    if(b)
    {
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedTextRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.item = result;
            int wzcount = [[result objectForKey:@"wzcount"] intValue];
            if(wzcount)
            {

            }
            
            return;
        }
        else
        {
            [RCTool showAlert:@"提示" message:error];
        }
        
        return;
    }
    
}

#pragma mark - Buttons

- (void)initButtons
{
  
}

- (void)clickedCalculatorButton:(id)sender
{
    NSLog(@"clickedCalculatorButton");
}


@end
