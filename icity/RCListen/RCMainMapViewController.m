//
//  RCMainMapViewController.m
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMainMapViewController.h"

@interface RCMainMapViewController ()

@end

@implementation RCMainMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _pointArray = [[NSMutableArray alloc] init];

        [self initTitleView];
        
        [self initPopMenu];
        
    }
    return self;
}

- (void)dealloc
{
    self.titleMenuArray = nil;
    
    self.titleView = nil;
    
    self.popMenuView = nil;
    
    self.current_jq = nil;
    
    self.pointArray = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_titleView)
       [[RCTool frontWindow] addSubview:_titleView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_titleView)
        [_titleView removeFromSuperview];
    
    [self hidePopView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item titleMenu:(NSArray*)array
{
    if(nil == item)
        return;
    
    if(_titleView)
    [_titleView updateContent:[item objectForKey:@"jq_name"]];
    
    self.current_jq = item;
    self.titleMenuArray = array;
    [self initPopMenu];
    
    [self updatePoint];
}

#pragma mark - Title View

- (void)initTitleView
{
    if(nil == _titleView)
    {
        _titleView = [[RCMainTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _titleView.center = CGPointMake([RCTool getScreenSize].width/2.0, 40);
        _titleView.delegate = self;
        //[_titleView updateContent:@"test"];
        
        [[RCTool frontWindow] addSubview: _titleView];
    }

}

- (void)clickedTitleView:(id)sender
{
    if(_titleView)
    {
        if(_popMenuView)
        {
            if(nil == _popMenuView.superview)
                [[RCTool frontWindow] addSubview:_popMenuView];
            else
                [_popMenuView removeFromSuperview];
        }
    }
}

#pragma mark - Pop Menu

- (void)initPopMenu
{
    if(nil == _popMenuView)
    {
        _popMenuView = [[RCPopMenuView alloc] initWithFrame:CGRectMake(110, 50, 100, 200)];
        _popMenuView.delegate = self;
    }
    
    [_popMenuView updateContent:_titleMenuArray];
}

- (void)clickedPopMenuItem:(id)token
{
    int index = (int)token;
    if(index < [_titleMenuArray count])
    {
       self.current_jq = [_titleMenuArray objectAtIndex:index];
        [_titleView updateContent:[self.current_jq objectForKey:@"jq_name"]];
        
        [self updatePoint];
        
        if(_popMenuView && _popMenuView.superview)
            [_popMenuView removeFromSuperview];
    }
}

- (void)hidePopView
{
    if(_popMenuView && _popMenuView.superview)
        [_popMenuView removeFromSuperview];
}

#pragma mark -

- (void)updatePoint
{
    NSString* jq_id = @"";
    if(self.current_jq)
        jq_id = [self.current_jq objectForKey:@"jq_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jdlist&jq_id=%@",BASE_URL,jq_id];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    [temp request:urlString delegate:self resultSelector:@selector(finishedListRequest:) token:nil];
}

- (void)finishedListRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        if([RCTool hasNoError:result])
        {
            NSArray* data = [result objectForKey:@"data"];
            if(data && [data isKindOfClass:[NSArray class]])
            {
                [_pointArray removeAllObjects];
                [_pointArray addObjectsFromArray:data];
            }
        }
        
        NSDictionary* token = [NSDictionary dictionaryWithObject:_pointArray forKey:@"points"];
        [super updateContent:token];
    }
}


@end
