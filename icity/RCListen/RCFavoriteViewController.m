//
//  RCFavoriteViewController.m
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCFavoriteViewController.h"
#import "RCHttpRequest.h"
#import "RCJingDianViewController.h"

@interface RCFavoriteViewController ()

@end

@implementation RCFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"收藏夹";
    
    if(_itemArray && _tableView)
    {
        [_itemArray removeAllObjects];
        [self.tableView reloadData];
    }
    
    [self updateContent];
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


- (void)updateContent
{
    {
        //http://acs.akange.com:81/index.php?c=main&a=getsc&token=renykang
        
        NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=getsc&token=%@",BASE_URL,[RCTool getDeviceID]];
        
        RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
        BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedSearchRequest:) token:nil];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
}

- (void)finishedSearchRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
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
        else{
            NSString* msg = [result objectForKey:@"msg"];
            if([msg length])
                [RCTool showAlert:@"提示" message:msg];
        }
        
        if(self.tableView)
            [self.tableView reloadData];
    }
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        CGFloat height = [RCTool getScreenSize].height;
        if([RCTool systemVersion] < 7.0)
            height -= NAVIGATION_BAR_HEIGHT;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,height)
                                                  style:UITableViewStylePlain];
        //_tableView.backgroundColor = BG_COLOR;
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
    
	[self.view addSubview:_tableView];
    
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId0];
        
        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary* item = [self getCellDataAtIndexPath:indexPath];
    if(item)
    {
        cell.textLabel.text = [item objectForKey:@"jd_name"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSDictionary* item = [self getCellDataAtIndexPath:indexPath];
    if(item)
    {
        RCJingDianViewController* controller = [[RCJingDianViewController alloc] initWithNibName:nil bundle:nil];
        [controller updateContent:item];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

@end
