//
//  RCPointOverlayView.m
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPointOverlayView.h"

@implementation RCPointOverlayView

- (id)initWithOverlay:(id <BMKOverlay>)overlay;
{
    self = [super initWithOverlay:overlay];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay"]];
        [self addSubview:imageView];
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

@end
