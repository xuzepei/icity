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
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initWaterfallView];
    
    if(_waterfallView)
        [_waterfallView reloadData];
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
    NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=getpiclist&jq_id=%@&pid=%@",BASE_URL,jq_id,self.pid];
    
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
        _waterfallView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height)];
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
    
    return cell;
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
	
    return 2.0;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightAtIndexPath:indexPath] / [self quiltViewNumberOfColumns:quiltView];
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

@end
