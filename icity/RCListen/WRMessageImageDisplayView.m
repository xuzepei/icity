//
//  WRMessageImageDisplayView.m
//  WRadio
//
//  Created by xu zepei on 2/8/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import "WRMessageImageDisplayView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

#define IMAGE_MAX_WIDTH 260
#define IMAGE_MAX_HEIGHT 360

@implementation WRMessageImageDisplayView
@synthesize _dict;
@synthesize _displayButton;
@synthesize _indicatorView;
@synthesize _imageView;
@synthesize _imageUrl;
@synthesize _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code  480-20/2   
        self.alpha = 0.0;
        self.backgroundColor = [UIColor colorWithPatternImage:
                                [RCTool isIphone5]?[UIImage imageNamed:@"image_display_view_bg-568h@2x.png"]:[UIImage imageNamed:@"image_display_view_bg.png"]];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.center = CGPointMake(160.0, [RCTool getScreenSize].height/2 - 10);
        [self addSubview:_imageView];
        
        _displayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,111, 32)];
        [_displayButton setImage:[UIImage imageNamed:@"display_full_image_button"] forState:UIControlStateNormal];
        [_displayButton setImage:[UIImage imageNamed:@"display_full_image_button_selected"] forState:UIControlStateHighlighted];
        [_displayButton addTarget:self action:@selector(clickDisplayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: _displayButton];
        _displayButton.center = CGPointMake(160.0, [RCTool getScreenSize].height - 20  - 40/2.0);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_dict release];
    [_displayButton release];
    [_indicatorView release];
    [_imageView release];
    [_imageUrl release];
    self._delegate = nil;
    
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

- (void)updateContent:(NSDictionary*)dict
{
    self._dict = dict;
    
    _imageView.image = [UIImage imageNamed:@"message_default_photo.png"];
    
    if(_dict)
    {
        NSString* imageUrl0 = [_dict objectForKey:@"url"];
        if([imageUrl0 length])
        {
            UIImage* image = [RCTool getImageFromLocal:imageUrl0];
            if(image)
                _imageView.image = image;
        }
        
        NSString* imageUrl1 = [_dict objectForKey:@"url"];
        if([imageUrl1 length])
        {
            self._imageUrl = imageUrl1;
            UIImage* image = [RCTool getImageFromLocal:_imageUrl];
            if(nil == image)
            {	
                RCImageLoader* temp = [RCImageLoader sharedInstance];
                [temp saveImage:_imageUrl delegate:self token:nil];
            } 
            else
            {
                _imageView.image = image;
            }
        }
    }
    
    CGRect imageRect = [self getImageViewRect:CGRectMake(0,0, _imageView.image.size.width, _imageView.image.size.height)];
    _imageView.frame = CGRectZero;
    _imageView.center = CGPointMake(160.0, 230.0 - 40);

    [UIView beginAnimations:@"resizeImageView"
					context:nil];
	[UIView setAnimationDuration:0.3];
    _imageView.frame = CGRectMake((320 - imageRect.size.width)/2.0, (420 - imageRect.size.height)/2.0, imageRect.size.width, imageRect.size.height);
	[UIView commitAnimations];
}

- (void)displayView
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [UIView beginAnimations:@"displayMessageImageDisplayView" 
					context:nil];
	[UIView setAnimationDuration:0.5];
	self.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)closeView
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView beginAnimations:@"closeMessageImageDisplayView" 
					context:nil];
	[UIView setAnimationDuration:0.5];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)clickDisplayButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(displayFullImage:)])
    {
        NSString* imageUrl2 = [_dict objectForKey:@"url"];
        if([imageUrl2 length])
        {
            [_delegate displayFullImage:imageUrl2];
        }
    }
}

#pragma mark -
#pragma mark RCImageLoader Delegate

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
	
	if([urlString isEqualToString: _imageUrl])
	{
		UIImage* image = [RCTool getImageFromLocal:_imageUrl];
        if(image)
        {
            _imageView.image = image;
            CGRect imageRect = [self getImageViewRect:CGRectMake(0,0, _imageView.image.size.width, _imageView.image.size.height)];
            //_imageView.frame = CGRectZero;
            _imageView.center = CGPointMake(160.0, 230.0 - 40);
            
            [UIView beginAnimations:@"resizeImageView" 
                            context:nil];
            [UIView setAnimationDuration:0.3];
            _imageView.frame = CGRectMake((320 - imageRect.size.width)/2.0, (420 - imageRect.size.height)/2.0, imageRect.size.width, imageRect.size.height);
            [UIView commitAnimations];
        }
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeView];
    [super touchesEnded:touches withEvent:event];
}

@end
