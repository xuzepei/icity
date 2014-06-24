//
//  RCXiangCeViewController.m
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCXiangCeViewController.h"
#import "RCHttpRequest.h"
#import "RCWebViewController.h"
#import "RCImageLoader.h"
#import "RCUploadPhotoViewController.h"

#define BG_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:234/255.0 alpha:1.0]
#define CELL_OFFSET_HEIGHT 42.0f

@interface RCXiangCeViewController ()

@end

@implementation RCXiangCeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"景点相册";
        
        _itemArray = [[NSMutableArray alloc] init];
        _imageArray = [[NSMutableArray alloc] init];
        
        self.view.backgroundColor = BG_COLOR;
        
        UIImage *image = [UIImage imageNamed:@"upload_btn"];
//        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem* rightItem = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedUploadButtonItem:)] autorelease];
        
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

- (void)dealloc
{
    self.itemArray = nil;
    self.item = nil;
    self.pid = @"0";
    self.waterfallView = nil;
    self.imageArray = nil;
    self.galleryController = nil;
    self.willReplaceItem = nil;
    
    self.shareView = nil;
    self.cancelShareButton = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initWaterfallView];
    
    if(_waterfallView)
        [_waterfallView reloadData];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"景点相册";
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

- (void)clickedUploadButtonItem:(id)sender
{
    NSLog(@"clickedUploadButtonItem");
    NSString* jd_id = @"";
    if(self.item)
        jd_id = [self.item objectForKey:@"jd_id"];
    
    if(0 == [jd_id length])
        return;
    
    
    RCUploadPhotoViewController* temp = [[RCUploadPhotoViewController alloc] initWithNibName:nil bundle:nil];
    temp.jqid = jd_id; //用景点id
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    //http://acs.akange.com:81/index.php?c=main&a=getpiclist&jq_id=1&pid=0
    
    NSString* jq_id = @"";
    if(self.item)
        jq_id = [self.item objectForKey:@"jd_jq_id"];
    
    NSString* pid = nil;
    if(0 == [self.itemArray count])
        pid = @"0";
    else
    {
        NSDictionary* lastItem = [self.itemArray lastObject];
        pid = [lastItem objectForKey:@"p_id"];
    }
    
    if(0 == [pid length] || [pid isEqualToString:self.pid] || self.isLoading)
        return;
    
    self.pid = pid;
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=getpiclist&jq_id=%@&pid=%@&token=%@",BASE_URL,jq_id,self.pid,[RCTool getDeviceID]];
    
    NSLog(@"urlString:%@",urlString);
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:nil];
    if(b)
    {
        self.isLoading = YES;
        
        [RCTool showIndicator:@"加载中..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    
    [RCTool hideIndicator];
    
    self.isLoading = NO;
    
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
                //[self.itemArray removeAllObjects];
                [self.itemArray addObjectsFromArray:array];
            }
            
            if(_waterfallView)
                [_waterfallView reloadData];
        }
        else
        {
            [RCTool showAlert:@"提示" message:[result objectForKey:@"msg"]];
            return;
        }
    }
}

#pragma mark - Waterfall View

- (void)initWaterfallView
{
    if(nil == _waterfallView)
    {
        CGFloat height = [RCTool getScreenSize].height;
        if([RCTool systemVersion] < 7.0)
            height -= NAVIGATION_BAR_HEIGHT;
        
        _waterfallView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, height)];
    }
    
	_waterfallView.delegate = self;
	_waterfallView.dataSource = self;
	
	[self.view addSubview:_waterfallView];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    if (offsetY > contentHeight - scrollView.frame.size.height)
    {
        [self updateContent:self.item];
    }
}

#pragma mark - TMQuiltViewDelegate

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [_itemArray count])
    {
        NSDictionary* item = [_itemArray objectAtIndex:indexPath.row];
        if(item)
        {
            CGFloat height = [[item objectForKey:@"p_height"] floatValue];
            return height*2;
        }
    }
    
    
    return 0.0;
}

- (NSString *)textAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [_itemArray count])
    {
        NSDictionary* item = [_itemArray objectAtIndex:indexPath.row];
        if(item)
        {
            NSString* desc = [item objectForKey:@"p_desc"];
            if([desc length])
            {
                return desc;
            }
        }
    }
    
    
    return @"";
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [_itemArray count])
    {
        NSDictionary* item = [_itemArray objectAtIndex:indexPath.row];
        if(item)
        {
            NSString* imageUrl = [item objectForKey:@"p_url_sl"];
            if([imageUrl length])
            {
                UIImage* image = [RCTool getImageFromLocal:imageUrl];
                if(image)
                    return image;
                else
                {
                    [[RCImageLoader sharedInstance] saveImage:imageUrl
                                                     delegate:self
                                                        token:nil];
                }
            }
        }
    }
    
    
    return nil;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return [_itemArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    
    cell.photoView.image = [self imageAtIndexPath:indexPath];
    cell.titleLabel.text = [self textAtIndexPath:indexPath];
    
    //获取点赞次数
    if(indexPath.row < [_itemArray count])
    {
        NSDictionary* item = [_itemArray objectAtIndex:indexPath.row];
        if(item)
        {
            NSString* likecount = @"0";
            id temp = [item objectForKey:@"p_likes_cnt"];
            if([temp isKindOfClass:[NSString class]])
            {
                if([temp length])
                    likecount = temp;
            }
            else
                likecount = [NSString stringWithFormat:@"%d",[temp intValue]];
            
            cell.item = item;
            cell.delegate = self;
            cell.zanLabel.text = likecount;
        }
    }
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
	
    return 2.0;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightAtIndexPath:indexPath] / [self quiltViewNumberOfColumns:quiltView] + CELL_OFFSET_HEIGHT;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"index:%d",indexPath.row);
    
    if(indexPath.row < [_itemArray count])
    {
        NSDictionary* item = [_itemArray objectAtIndex:indexPath.row];
        if(item)
        {
            NSArray* imageArray = [item objectForKey:@"plist"];
            if([imageArray count])
            {
                [self.imageArray removeAllObjects];
                [self.imageArray addObjectsFromArray:imageArray];
                [self initGalleryController];
            }
        }
    }
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
	//if([urlString isEqualToString: self.imageUrl])
	{
		//self.image = [RCTool getImageFromLocal:self.imageUrl];
        if(_waterfallView)
		[_waterfallView reloadData];
	}
}

- (void)clickedLikeButton:(BOOL)isLiked token:(NSDictionary *)token
{
    NSString* a = @"";
    if(isLiked)
    {
        a = @"addlikeflag";
    }
    else
    {
        a = @"dellikeflag";
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=%@&pid=%@&token=%@",BASE_URL,a,[token objectForKey:@"p_id"],[RCTool getDeviceID]];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedZanRequest:) token:nil];
    if(b)
    {
        NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict addEntriesFromDictionary:token];
        [dict setObject:[NSNumber numberWithBool:isLiked] forKey:@"isLiked"];
        int count = [[dict objectForKey:@"p_likes_cnt"] intValue];
        if(isLiked)
            count++;
        else
            count--;

        count = MAX(count,0);
        [dict setObject:[NSNumber numberWithInt:count] forKey:@"p_likes_cnt"];
        self.willReplaceItem = dict;

        
        [RCTool showIndicator:@"加载中..."];
    }
}

- (void)finishedZanRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        if([RCTool hasNoError:result])
        {
            NSLog(@"成功");
            
            NSString* temp_p_id = [self.willReplaceItem objectForKey:@"p_id"];
            
            int index = -1;
            int i = 0;
            for(NSDictionary* item in _itemArray)
            {
                NSString* p_id = [item objectForKey:@"p_id"];
                if([p_id isEqualToString:temp_p_id])
                {
                    index = i;
                    break;
                }
                
                i++;
            }
            
            if(index != -1 && self.willReplaceItem)
            {
                [_itemArray replaceObjectAtIndex:index withObject:self.willReplaceItem];
                [_waterfallView reloadData];
            }
        }
        else
        {
            self.willReplaceItem = nil;
            [RCTool showAlert:@"提示" message:[result objectForKey:@"msg"]];
            return;
        }
    }
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (void)initGalleryController
{
    self.galleryController = [[[FGalleryViewController alloc] initWithPhotoSource:self] autorelease];
    
    [self.navigationController pushViewController:_galleryController animated:YES];
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == _galleryController)
    {
        return [self.imageArray count];
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
    if(index >= [self.imageArray count])
        return @"";
    
    NSDictionary* item = [self.imageArray objectAtIndex:index];
    if(item)
    {
        return [item objectForKey:@"p_url"];
    }
    
    return @"";
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

@end
