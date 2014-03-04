//
//  WRMessageFullImageDisplayController.h
//  WRadio
//
//  Created by xu zepei on 2/9/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRFullImageDisplayScrollView.h"

@interface WRMessageFullImageDisplayController : UIViewController
<UIScrollViewDelegate,WRFullImageDisplayScrollViewDelegate>
{
    WRFullImageDisplayScrollView *imageScrollView;
	UIImageView *imageView;
    NSString* _imageUrl;
    UIActivityIndicatorView* _indicatorView;
}

@property (nonatomic, retain) WRFullImageDisplayScrollView *imageScrollView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString* _imageUrl;
@property (nonatomic, retain) UIActivityIndicatorView* _indicatorView;

- (void)updateContent:(NSString*)imageUrl;
- (void)setNavigationBarHide;

@end
