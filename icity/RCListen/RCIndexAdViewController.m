//
//  RCIndexAdViewController.m
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCIndexAdViewController.h"
#import "RCIndexAdCell0.h"
#import "RCIndexAdCell1.h"
#import "RCHttpRequest.h"
#import "RCImageLoader.h"
#import "RCIndexAdCell2.h"
#import "RCWebViewController.h"

@interface RCIndexAdViewController ()

@end

@implementation RCIndexAdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0];
        //titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.text = @"标题";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = NAVIGATION_BAR_TITLE_COLOR;
        self.navigationItem.titleView = titleLabel;
        [titleLabel sizeToFit];
        
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.tableView = nil;
    self.content = nil;
    self.itemArray = nil;
    
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0, 52, 33);
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanhui_on"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickedLeftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    UILabel* titleLabel = (UILabel*)self.navigationItem.titleView;
    titleLabel.text = [self.item objectForKey:@"title"];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/index_ad_content.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    NSString* token = [NSString stringWithFormat:@"id=%@",[self.item objectForKey:@"id"]];
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
    
    [_tableView reloadData];
}

- (void)finishedRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        self.content = result;
        
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSString* url = [result objectForKey:@"img"];
            if([url length])
            {
                if([url length])
                {
                    [_itemArray addObject:url];
                    UIImage* image = [RCTool getImageFromLocal:url];
                    if(nil == image)
                    {
                        RCImageLoader* temp = [RCImageLoader sharedInstance];
                        [temp saveImage:url delegate:self token:nil];
                    }
                }
            }
            
            NSArray* urlArray = [result objectForKey:@"imglist"];
            if(urlArray && [urlArray isKindOfClass:[NSArray class]])
            {
                //[_itemArray removeAllObjects];
                
                for(NSDictionary* dict in urlArray)
                {
                    NSString* url = [dict objectForKey:@"url"];
                    if([url length])
                    {
                        [_itemArray addObject:url];
                        
                        UIImage* image = [RCTool getImageFromLocal:url];
                        if(nil == image)
                        {
                            RCImageLoader* temp = [RCImageLoader sharedInstance];
                            [temp saveImage:url delegate:self token:nil];
                        }
                    }
                }
            }
            
            [self.tableView reloadData];
            
            return;
        }
        else
        {
            [RCTool showAlert:@"提示" message:error];
        }
        
        return;
    }
    
}


#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        CGFloat tabBarHeight = TAB_BAR_HEIGHT;
        if(self.hidesBottomBarWhenPushed)
            tabBarHeight = 0.0;
        
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - tabBarHeight)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
	
	[self.view addSubview:_tableView];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
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
    return 0;
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    if(0 == indexPath.row)
        return 140.0;
    else if(1 == indexPath.row)
        return 220.0;
    else
    {
        CGFloat height = 50.0;
        NSString* title = [self.content objectForKey:@"content"];
        if([title length])
        {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            height += MAX(size.height + 20.0, 20.0);
        }
        
        return height;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCIndexAdCell0" owner:self options:nil];
            cell = [objects objectAtIndex:0];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if(self.content)
        {
            RCIndexAdCell0* temp = (RCIndexAdCell0*)cell;
            NSString* url = [self.content objectForKey:@"img"];
            if([url length])
            {
                UIImage* image = [RCTool getImageFromLocal:url];
                if(image)
                    temp.myImageView.image = image;
            }
        }
        
    }
    else if(1 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCIndexAdCell1" owner:self options:nil];
            cell = [objects objectAtIndex:0];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if(self.content)
        {
            RCIndexAdCell1* temp = (RCIndexAdCell1*)cell;
            temp.myLabel.text = [self.content objectForKey:@"title"];
            NSArray* array = [self.content objectForKey:@"imglist"];
            if([array isKindOfClass:[NSArray class]] && array)
            {
                if([array count])
                {
                    NSDictionary* item = [array objectAtIndex:0];
                    UIImage* image = [RCTool getImageFromLocal:[item objectForKey:@"url"]];
                    if(image)
                        temp.im0.image = image;
                }
                
                if([array count] > 1)
                {
                    NSDictionary* item = [array objectAtIndex:1];
                    UIImage* image = [RCTool getImageFromLocal:[item objectForKey:@"url"]];
                    if(image)
                        temp.im1.image = image;
                }
                
                if([array count] > 2)
                {
                    NSDictionary* item = [array objectAtIndex:2];
                    UIImage* image = [RCTool getImageFromLocal:[item objectForKey:@"url"]];
                    if(image)
                        temp.im2.image = image;
                }
                
                if([array count] > 3)
                {
                    NSDictionary* item = [array objectAtIndex:3];
                    UIImage* image = [RCTool getImageFromLocal:[item objectForKey:@"url"]];
                    if(image)
                        temp.im3.image = image;
                }
            }
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if(cell == nil)
        {
            cell = [[[RCIndexAdCell2 alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId2] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if(self.content)
        {
            RCIndexAdCell2* temp = (RCIndexAdCell2*)cell;
            NSMutableAttributedString* linkString = [[NSMutableAttributedString alloc] initWithString:[self.content objectForKey:@"link"]];
            [linkString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [linkString length])];
            
            [temp.linkButton setAttributedTitle:linkString forState:UIControlStateNormal];
            [temp updateContent:[self.content objectForKey:@"content"] height:[self getCellHeight:indexPath] delegate:self];
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(2 != indexPath.row)
    {
        [self initGalleryController];
    }
}


- (void)clickedLinkButton:(id)sender
{
    NSLog(@"clickedLinkButton");
    
    RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
    temp.hidesBottomBarWhenPushed = YES;
    [temp updateContent:[self.content objectForKey:@"link"] title:nil];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}


#pragma mark - RCImageLoader Delegate

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
	
    //if([urlString isEqualToString: self.imageUrl])
	{
		[_tableView reloadData];
	}
}

- (void)initGalleryController
{
    if(nil == _galleryController)
    {
        _galleryController = [[FGalleryViewController alloc] initWithPhotoSource:self];
    }
    
    
    [self.navigationController pushViewController:_galleryController animated:YES];
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == _galleryController)
    {
        return [_itemArray count];
    }
    
	return 0;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
	return @"";
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    
    return @"";
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    if(index >= [_itemArray count])
        return @"";
    
    return [_itemArray objectAtIndex:index];
}



@end
