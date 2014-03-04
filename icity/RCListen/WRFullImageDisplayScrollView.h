//
//  WRFullImageDisplayView.h
//  WRadio
//
//  Created by xu zepei on 2/9/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WRFullImageDisplayScrollViewDelegate <NSObject>
@optional
- (void)setNavigationBarHide;

@end

@interface WRFullImageDisplayScrollView : UIScrollView
{
}

@end
