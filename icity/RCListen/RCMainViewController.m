//
//  RCMainViewController.m
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCHttpRequest.h"
#import "RCPublicCell.h"
#import "RCJingDianViewController.h"
#import "RCWebViewController.h"
#import "RCSearchViewController.h"
#import "RCFavoriteViewController.h"

#define AD_HEIGHT 160.0

@interface RCMainViewController ()

@end

@implementation RCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _adArray = [[NSMutableArray alloc] init];
        _itemArray = [[NSMutableArray alloc] init];
        _titleMenuArray = [[NSMutableArray alloc] init];
        
        [self initTitleView];
        
        [self initPopMenu2];

//        self.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
//        //self.refreshControl.tintColor = [UIColor orangeColor];
//        //self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
//        [self.refreshControl addTarget:self action:@selector(updateContent) forControlEvents:UIControlEventValueChanged];
        
        UIImage *image = [UIImage imageNamed:@"back_button"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem* leftItem = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedLeftButtonItem:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
        image = [UIImage imageNamed:@"list_item"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem* rightItem = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedRightButtonItem:)] autorelease];
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    return self;
}

- (void)dealloc
{
    self.adArray = nil;
    self.itemArray = nil;
    self.adScrollView = nil;
    self.item = nil;
    self.current_jq = nil;
    self.titleView = nil;
    self.popMenuView = nil;
    self.popMenuView2 = nil;
    self.refreshHeaderView = nil;
    
    if(self.adView != nil)
    {
        AdwoAdRemoveAndDestroyBanner(self.adView);
        self.adView = nil;
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initAdScrollView];
    
    [self updateTitleMenu];
    
    [self updateAd];
    
    [self initAd];
    
    [self initRefreshHeaderView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hidePopView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedLeftButtonItem:(id)sender
{

}

- (void)clickedRightButtonItem:(id)sender
{
    if(_popMenuView2)
    {
        if(nil == _popMenuView2.superview)
        {
            [[RCTool frontWindow] addSubview:_popMenuView2];
            
            if(_popMenuView && _popMenuView.superview)
                [_popMenuView removeFromSuperview];
        }
        else
            [_popMenuView2 removeFromSuperview];
    }
}

- (void)updateTitleMenu
{
    //http://acs.akange.com:81/index.php?c=main&a=jqlist
    
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jqlist",BASE_URL];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    [temp request:urlString delegate:self resultSelector:@selector(finishedTitleMenuRequest:) token:nil];
}

- (void)finishedTitleMenuRequest:(NSString*)jsonString
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
                [_titleMenuArray removeAllObjects];
                [_titleMenuArray addObjectsFromArray:data];
            }
        }
        
        [self initPopMenu];
        [self clickedPopMenuItem:0];
    }
}

- (void)updateContent
{
    NSString* jq_id = @"";
    if(self.current_jq)
        jq_id = [self.current_jq objectForKey:@"jq_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=jdlist&jq_id=%@",BASE_URL,jq_id];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedListRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedListRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    //[self.refreshControl endRefreshing];
    
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
                [_itemArray removeAllObjects];
                [_itemArray addObjectsFromArray:data];
            }
        }
        
        if(self.tableView)
            [self.tableView reloadData];
    }
}

#pragma mark - Title View

- (void)initTitleView
{
    _titleView = [[RCMainTitleView alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    _titleView.delegate = self;
    [_titleView updateContent:@"成都"];
    self.navigationItem.titleView = _titleView;
}

- (void)clickedTitleView:(id)sender
{
    if(_titleView)
    {
        if(_popMenuView)
        {
            if(nil == _popMenuView.superview)
            {
                [[RCTool frontWindow] addSubview:_popMenuView];
                
                if(_popMenuView2 && _popMenuView2.superview)
                    [_popMenuView2 removeFromSuperview];
            }
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
        
        [self updateContent];
        
        if(_popMenuView && _popMenuView.superview)
            [_popMenuView removeFromSuperview];
    }
}

- (void)hidePopView
{
    if(_popMenuView && _popMenuView.superview)
        [_popMenuView removeFromSuperview];
    
    if(_popMenuView2 && _popMenuView2.superview)
        [_popMenuView2 removeFromSuperview];
}

- (void)initPopMenu2
{
    if(nil == _popMenuView2)
    {
        _popMenuView2 = [[RCPopMenuView2 alloc] initWithFrame:CGRectMake(210, 60, 100, 200)];
        _popMenuView2.delegate = self;
    }
    
    [_popMenuView2 updateContent];
}

- (void)clickedPopMenu2Item:(id)token
{
    int index = (int)token;
    if(0 == index)
    {
        if(self.current_jq)
        {
            RCMainMapViewController* temp = [[RCMainMapViewController alloc] initWithNibName:nil bundle:nil];
            [temp updateContent:self.current_jq titleMenu:self.titleMenuArray];
            [self.navigationController pushViewController:temp animated:YES];
            [temp release];
        }
    }
    else if(1 == index)
    {
        RCSearchViewController* temp = [[RCSearchViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else if(2 == index)
    {
        RCFavoriteViewController* temp = [[RCFavoriteViewController alloc] initWithNibName:nil bundle:nil];
        //[temp updateContent];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
}

#pragma mark - AdScrollView

- (void)initAdScrollView
{
    if(nil == _adScrollView)
    {
        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_HEIGHT)];
        _adScrollView.delegate = self;
    }
    
    [_adScrollView updateContent:_adArray];
    
    if(self.tableView)
        [self.tableView reloadData];
}

- (void)updateAd
{
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=indexpic",BASE_URL];
    
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
        if([RCTool hasNoError:result])
        {
            NSArray* data = [result objectForKey:@"data"];
            if(data && [data isKindOfClass:[NSArray class]])
            {
                [_adArray removeAllObjects];
                [_adArray addObjectsFromArray:data];
            }
        }
        
        [self initAdScrollView];
    }
}


- (void)clickedAd:(id)token
{
    NSLog(@"clickedAd");
    
    [self hidePopView];
    
    NSDictionary* item = (NSDictionary*)token;
    if(nil == item)
        return;
    
    NSString* ip_linkurl = [item objectForKey:@"ip_linkurl"];
    if(0 == [ip_linkurl length])
    {
        return;
    }
    else if([ip_linkurl length] <= 5)
    {
        NSString* jd_name = [item objectForKey:@"ip_name"];
        if(0 == [jd_name length])
            jd_name = @"";
        
        NSString* jd_id = ip_linkurl;
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:jd_name,@"jd_name",jd_id,@"jd_id",nil];
        
        RCJingDianViewController* controller = [[RCJingDianViewController alloc] initWithNibName:nil bundle:nil];
        [controller updateContent:dict];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if([ip_linkurl length] > 5)
    {
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:ip_linkurl title:[item objectForKey:@"ip_name"]];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }

}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - 50)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
    }

	[self.view addSubview:_tableView];

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;//[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;//[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    return 84.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
        return 1;
    else if(1 == section)
        return [_itemArray count];
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        return AD_HEIGHT;
    }
    else if(1 == indexPath.section)
        return [self getCellHeight:indexPath];
    
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            [cell.contentView addSubview: _adScrollView];
        }
    }
    else if(1 == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier: cellId1 contentViewClass:NSClassFromString(@"RCMainListCellContentView")] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        RCPublicCell* temp = (RCPublicCell*)cell;
        if(temp)
        {
            NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
            [temp updateContent:item cellHeight:[self getCellHeight:indexPath] delegate:self token:dict];
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    [self hidePopView];
    
    if(1 == indexPath.section)
    {
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];

        RCJingDianViewController* controller = [[RCJingDianViewController alloc] initWithNibName:nil bundle:nil];
        [controller updateContent:item];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark - AD

- (void)initAd
{
    self.adView = nil;
    
    //创建广告对象
    _adView = AdwoAdCreateBanner(AD_ID, YES, self);
    if(nil == _adView)
    {
        NSLog(@"Adwo ad view failed to create!");
        return;
    }
    
    // 设置AWAdView的位置（这里对frame设置大小将不起作用）
    self.adView.frame = CGRectMake(0.0f,[RCTool getScreenSize].height - 50, 0.0f, 0.0f);
    
    // 将adView添加到本视图中（注意，在调用loadAd前必须先将adView添加到一个父视图中）
    
    [self.view addSubview:self.adView];
    
    if(AdwoAdLoadBannerAd(self.adView, ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER))
    {
        NSLog(@"Ad view has been loaded!");
    }
    else
    {
        NSLog(@"Ad view failed to load");
    }
}

// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

#pragma mark - Refresh Header View

- (void)initRefreshHeaderView
{
	if (nil == _refreshHeaderView) {
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
							  CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height,
										 [RCTool getScreenSize].width, self.tableView.bounds.size.height)];

		self.refreshHeaderView.delegate = self;
        [self.tableView addSubview:self.refreshHeaderView];
	}
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	if (_refreshHeaderView)
		[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
				  willDecelerate:(BOOL)decelerate{
	
	if (_refreshHeaderView)
		[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self updateContent];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.isDragLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return @"";
}

@end
