//
//  RCJiuDianViewController.m
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJiuDianViewController.h"

#define HEADER_VIEW_HEIGHT 40.0f
#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101

@interface RCJiuDianViewController ()

@end

@implementation RCJiuDianViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"酒店住宿";
    }
    return self;
}

- (void)dealloc
{
    self.pickerView = nil;
    self.fanweiSelection = nil;
    self.leibieSelection = nil;
    self.headerButton0 = nil;
    self.headerButton1 = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initPickerView];
    
    [self initHeaderView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Header View

- (void)initHeaderView
{
    //范围
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"范围" forKey:@"name"];
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:@"不限"];
    [array addObject:@"范围1"];
    [array addObject:@"范围2"];
    [array addObject:@"范围3"];
    [array addObject:@"范围4"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON0_TAG] forKey:@"tag"];
    self.fanweiSelection = dict;
    
    //类别
    dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"类别" forKey:@"name"];
    array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:@"不限"];
    [array addObject:@"类别1"];
    [array addObject:@"类别2"];
    [array addObject:@"类别3"];
    [array addObject:@"类别4"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON1_TAG] forKey:@"tag"];
    self.leibieSelection = dict;
 
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, HEADER_VIEW_HEIGHT)] autorelease];
    
    if(nil == _headerButton0)
    {
        _headerButton0 = [[RCButtonView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width/2.0, HEADER_VIEW_HEIGHT)];
        _headerButton0.delegate = self;
        _headerButton0.tag = HEADER_BUTTON0_TAG;
        [_headerButton0 updateContent:@"范围"];
        [self.view addSubview: _headerButton0];
    }
    
    if(nil == _headerButton1)
    {
        _headerButton1 = [[RCButtonView alloc] initWithFrame:CGRectMake([RCTool getScreenSize].width/2.0, NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width/2.0, HEADER_VIEW_HEIGHT)];
        _headerButton1.delegate = self;
        _headerButton1.tag = HEADER_BUTTON1_TAG;
        [_headerButton1 updateContent:@"类型"];
        [self.view addSubview: _headerButton1];
    }
 
}

- (void)clickedHeaderButton:(int)tag token:(id)token
{
    NSLog(@"clickedHeaderButton");
    
    if(HEADER_BUTTON0_TAG == tag)
    {
        [_pickerView updateContent:self.fanweiSelection];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        [_pickerView updateContent:self.leibieSelection];
    }
    
    [_pickerView show];
}

#pragma mark - Picker View

- (void)initPickerView
{
    if(nil == _pickerView)
    {
        _pickerView = [[RCPickerView alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height, [RCTool getScreenSize].width, PICKER_VIEW_HEIGHT)];
        _pickerView.delegate = self;
    }
}

- (void)clickedSureValueButton:(int)index token:(id)token
{
    if(nil == token)
        return;
    
//    NSDictionary* dict = (NSDictionary*)token;
//    int tag = [[dict objectForKey:@"tag"] intValue];
//    if(HEADER_BUTTON0_TAG == tag)
//    {
//        _quyuIndex = index;
//        
//        NSString* temp = @"区域";
//        NSArray* array = [_quyuSelection objectForKey:@"values"];
//        NSDictionary* value = [array objectAtIndex: _quyuIndex];
//        if(_quyuIndex)
//            temp = [value objectForKey:@"name"];
//        self.quyuSearchId = [[value objectForKey:@"id"] intValue];
//        
//        [_headerButton0 updateContent:temp];
//    }
//    else if(HEADER_BUTTON1_TAG == tag)
//    {
//        _leixingIndex = index;
//        
//        NSString* temp = @"类型";
//        NSArray* array = [_leixingSelection objectForKey:@"values"];
//        NSDictionary* value = [array objectAtIndex: _leixingIndex];
//        if(_leixingIndex)
//            temp = [value objectForKey:@"name"];
//        self.leixingSearchId = [[value objectForKey:@"id"] intValue];
//        
//        [_headerButton1 updateContent:temp];
//    }
//    else if(HEADER_BUTTON2_TAG == tag)
//    {
//        _jiageIndex = index;
//        
//        NSString* temp = @"价格";
//        if(_jiageIndex)
//        {
//            NSArray* array = [_jiageSelection objectForKey:@"values"];
//            temp = [array objectAtIndex: _jiageIndex];
//        }
//        [_headerButton2 updateContent:temp];
//    }
//    else if(HEADER_BUTTON3_TAG == tag)
//    {
//        _paixuIndex = index;
//        
//        NSString* temp = @"排序";
//        if(_paixuIndex)
//        {
//            NSArray* array = [_paixuSelection objectForKey:@"values"];
//            temp = [array objectAtIndex: _paixuIndex];
//        }
//        
//        [_headerButton3 updateContent:temp];
//    }
//    
//    self.page = 1;
//    [_itemArray removeAllObjects];
//    [self updateContent];
}

@end
