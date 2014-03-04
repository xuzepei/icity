//
//  WRMessageFullImageDisplayController.m
//  WRadio
//
//  Created by xu zepei on 2/9/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import "WRMessageFullImageDisplayController.h"
#import "RCTool.h"
#import "RCImageLoader.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.0
#define IMAGE_MAX_WIDTH 320
#define IMAGE_MAX_HEIGHT [RCTool getScreenSize].height - 20 

@interface WRMessageFullImageDisplayController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation WRMessageFullImageDisplayController
@synthesize imageScrollView, imageView;
@synthesize _imageUrl;
@synthesize _indicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self wantsFullScreenLayout];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:[RCTool isIphone5]?@"display_full_image_bg-568h@2x.png":@"display_full_image_bg.png"]];
        
       
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = CGPointMake(160, 220);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        imageView.center = CGPointMake(160.0, [RCTool getScreenSize].height - 20 /2.0);
        [UIView commitAnimations];
        
        UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        [leftBarButtonItem release];
        
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [rightBarButtonItem release];
        
        imageScrollView = [[WRFullImageDisplayScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [RCTool getScreenSize].height - 20 )];
        imageScrollView.delegate = self;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview: imageScrollView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setTag:ZOOM_VIEW_TAG];
        [imageScrollView addSubview:imageView];
        
        //add gesture recognizers to the image view
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        [twoFingerTap setNumberOfTouchesRequired:2];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:twoFingerTap];
        
        [singleTap release];
        [doubleTap release];
        [twoFingerTap release];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    [super viewWillAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [super viewWillDisappear: animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [imageScrollView release];
    [imageView release];
    [_imageUrl release];
    [_indicatorView release];
    
    [super dealloc];
}

- (CGRect)getImageViewRect:(CGRect)rect
{
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    if(rect.size.width >= rect.size.height)
    {
        if(rect.size.width >= IMAGE_MAX_WIDTH)
        {
            height = (rect.size.height*IMAGE_MAX_WIDTH)/rect.size.width;
            
            return CGRectMake(rect.origin.x, rect.origin.y, IMAGE_MAX_WIDTH, height);
        }
        else
        {
            return CGRectMake(rect.origin.x,rect.origin.y, rect.size.height, rect.size.height);
        }
    }
    else
    {
        if(rect.size.width >= IMAGE_MAX_WIDTH)
            width = IMAGE_MAX_WIDTH;
        else
            width = rect.size.width;
        
        int i = 1.0;
        do{
            width -= i;
            height = (rect.size.height*width)/rect.size.width;
        }while(height > IMAGE_MAX_HEIGHT && width > 1.0);
        
        return CGRectMake(rect.origin.x, rect.origin.y, width, height);
    }
    
}

- (void)updateContent:(NSString*)imageUrl
{
    self._imageUrl = imageUrl;
    if([_imageUrl length])
    {
        UIImage* image = [RCTool getImageFromLocal:_imageUrl];
        if(nil == image)
        {	
            RCImageLoader* temp = [RCImageLoader sharedInstance];
            [temp saveImage:_imageUrl delegate:self token:nil];
        } 
        else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.view.backgroundColor = [UIColor blackColor];
            
            imageView.image = image;
            CGRect imageRect = [self getImageViewRect:CGRectMake(0,0, imageView.image.size.width, imageView.image.size.height)];
            imageView.frame = imageRect;
            
            float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
            [imageScrollView setMinimumZoomScale:0.5];
            [imageScrollView setZoomScale:minimumScale];
            [imageScrollView setMaximumZoomScale:10.0];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            CGSize size = imageScrollView.contentSize;
            imageView.center = CGPointMake(MAX(160.0,size.width/2.0), MAX(230.0,size.height/2.0));
            [UIView commitAnimations];
        }
    }
}

- (void)clickLeftBarButtonItem:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)clickRightBarButtonItem:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    UIImage* image = [RCTool getImageFromLocal:_imageUrl];
    if(image)
	{
		UIImageWriteToSavedPhotosAlbum(image, 
									   self, 
									   @selector(image:didFinishSavingWithError:contextInfo:), 
									   nil);
	}
}

- (void) image: (UIImage *) image
didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo
{
	if(0 == [error code])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"完成"
														message: NSLocalizedString(@"图片已经成功保存到相册。", @"")
													   delegate: self
											  cancelButtonTitle: NSLocalizedString(@"确定", @"")
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGSize size = imageScrollView.contentSize;
    imageView.center = CGPointMake(MAX(160.0,size.width/2.0), MAX(230.0,size.height/2.0));
    [UIView commitAnimations];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
    
    NSLog(@"handleTwoFingerTap");
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark -
#pragma mark RCImageLoader Delegate

- (void)startLoad:(id)token
{
    [self.view addSubview: _indicatorView];
    [_indicatorView startAnimating];
}

- (void)succeedLoad:(id)result token:(id)token
{
    [_indicatorView removeFromSuperview];
    [_indicatorView stopAnimating];
    
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
	
	if([urlString isEqualToString: _imageUrl])
	{
		UIImage* image = [RCTool getImageFromLocal:_imageUrl];
        if(image)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.view.backgroundColor = [UIColor blackColor];
            
            imageView.image = image;
            CGRect imageRect = [self getImageViewRect:CGRectMake(0,0, imageView.image.size.width, imageView.image.size.height)];
            imageView.frame = imageRect;
            
            float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
            [imageScrollView setMinimumZoomScale:0.5];
            [imageScrollView setZoomScale:minimumScale];
            [imageScrollView setMaximumZoomScale:1.5];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            CGSize size = imageScrollView.contentSize;
            imageView.center = CGPointMake(MAX(160.0,size.width/2.0), MAX(230.0,size.height/2.0));
            [UIView commitAnimations];
        }
	}
}

- (void)setNavigationBarHide
{
    NSLog(@"setNavigationBarHide");
    
    UIApplication* application = [UIApplication sharedApplication];
    [application setStatusBarHidden:application.statusBarHidden?NO:YES withAnimation:YES];
    
    [UIView beginAnimations:@"hideNavigationBar"
					context:nil];
	[UIView setAnimationDuration:1.0];
        self.navigationController.navigationBar.hidden = self.navigationController.navigationBar.hidden?NO:YES;
	[UIView commitAnimations];
    

}

@end
