//
//  RCMeiShiViewController.m
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeiShiViewController.h"
#import "RCHttpRequest.h"
#import "RCPublicCell.h"
#import "RCWebViewController.h"

#define HEADER_VIEW_HEIGHT 40.0f
#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101

#define BG_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:234/255.0 alpha:1.0]

@interface RCMeiShiViewController ()

@end

@implementation RCMeiShiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"美食推荐";
        
        _itemArray = [[NSMutableArray alloc] init];
        
        self.leibieValue = @"全部";
        self.fanweiValue = @"1000米";
        
        self.view.backgroundColor = BG_COLOR;
        
        UIImage *image = [UIImage imageNamed:@"map_item"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem* rightItem = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedMapButtonItem:)] autorelease];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

- (void)dealloc
{
    self.pickerView = nil;
    self.fanweiSelection = nil;
    self.leibieSelection = nil;
    self.fanweiValue = nil;
    self.leibieValue = nil;
    self.headerButton0 = nil;
    self.headerButton1 = nil;
    self.tableView = nil;
    self.itemArray = nil;
    self.item = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initPickerView];
    
    [self initHeaderView];
    
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"美食推荐";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.title = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedMapButtonItem:(id)sender
{
    NSLog(@"clickedMapButtonItem");
    
    if(0 == [self.itemArray count])
        return;
    
    RCJingDianMapViewController* temp = [[RCJingDianMapViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:self.itemArray title:self.title];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    //http://acs.akange.com:81/index.php?c=main&a=bdsearch&type=1&jd_id=1&tag=%E5%9B%9B%E6%98%9F%E7%BA%A7&pageno=0&radius=1000%E7%B1%B3
    
    NSString* tag = [self.leibieValue stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString* radius = [self.fanweiValue stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSString* jd_id = @"";
    if(self.item)
        jd_id = [self.item objectForKey:@"jd_id"];
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=bdsearch&type=0&jd_id=%@&tag=%@&pageno=%d&radius=%@",BASE_URL,jd_id,tag,self.pageno,radius];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"加载中..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        if([RCTool hasNoError:result])
        {
            NSArray* array = [result objectForKey:@"data"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                [self.itemArray addObjectsFromArray:array];
                
                self.pageno++;
            }
        }
    }
    
    if(self.tableView)
        [self.tableView reloadData];
}

#pragma mark - Header View

- (void)initHeaderView
{
    //范围
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"范围" forKey:@"name"];
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:@"500米"];
    [array addObject:@"1000米"];
    [array addObject:@"2000米"];
    [array addObject:@"5000米"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON0_TAG] forKey:@"tag"];
    self.fanweiSelection = dict;
    
    //类别
    dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"类别" forKey:@"name"];
    array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:@"全部"];
    [array addObject:@"中餐"];
    [array addObject:@"西餐"];
    [array addObject:@"日本菜"];
    [array addObject:@"韩国料理"];
    [array addObject:@"东南亚菜"];
    [array addObject:@"快餐"];
    [array addObject:@"甜点冷饮"];
    [array addObject:@"火锅"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON1_TAG] forKey:@"tag"];
    self.leibieSelection = dict;
    
    //    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, HEADER_VIEW_HEIGHT)] autorelease];
    
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
        [_headerButton1 updateContent:@"类别"];
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
    
    NSDictionary* dict = (NSDictionary*)token;
    int tag = [[dict objectForKey:@"tag"] intValue];
    if(HEADER_BUTTON0_TAG == tag)
    {
        NSArray* array = [_fanweiSelection objectForKey:@"values"];
        NSString* value = [array objectAtIndex:index];
        self.fanweiValue = value;
        
        [_headerButton0 updateContent:value];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        NSArray* array = [_leibieSelection objectForKey:@"values"];
        NSString* value = [array objectAtIndex:index];
        self.leibieValue = value;
        
        [_headerButton1 updateContent:value];
    }
    
    self.pageno = 0;
    
    [self.itemArray removeAllObjects];
    if(self.tableView)
        [self.tableView reloadData];
    
    [self updateContent:self.item];
    
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+HEADER_VIEW_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - (NAVIGATION_BAR_HEIGHT+HEADER_VIEW_HEIGHT))
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.showsVerticalScrollIndicator = NO;
    }
    
	[self.view addSubview:_tableView];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;//[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    return 120.0f;
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
        return [_itemArray count];
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        return [self getCellHeight:indexPath];
    }
    
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier: cellId1 contentViewClass:NSClassFromString(@"RCMeiShiCellContentView")] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = BG_COLOR;
            //        cell.backgroundView = [[UIView new] autorelease];
            //        cell.selectedBackgroundView = [[UIView new] autorelease];
        }
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        RCPublicCell* temp = (RCPublicCell*)cell;
        if(temp)
        {
            [temp updateContent:item cellHeight:[self getCellHeight:indexPath] delegate:self token:nil];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
        if(nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId0];
            
            cell.backgroundColor = BG_COLOR;
            cell.textLabel.text = @"更多...";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(1 == indexPath.section)
    {
        [self updateContent:self.item];
    }
}

#pragma mark -
- (void)clickedCell:(id)token
{
    NSLog(@"clickedCell");
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
    NSString* urlString = [item objectForKey:@"url"];
    if([urlString isKindOfClass:[NSString class]] && [urlString length])
    {
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:[item objectForKey:@"name"]];
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    
}

- (void)clickedLeftButton:(id)token
{
    NSLog(@"clickedLeftButton");
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
    NSArray* array = [NSArray arrayWithObject:item];
    RCRouteMapViewController* temp = [[RCRouteMapViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:array title:@"路径规划"];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}

- (void)clickedRightButton:(id)token
{
    NSLog(@"clickedRightButton");
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
    NSString* phoneNum = [item objectForKey:@"tel"];
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

@end
