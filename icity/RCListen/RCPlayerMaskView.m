//
//  RCPlayerMaskView.m
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPlayerMaskView.h"

@implementation RCPlayerMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage* bgImage = [UIImage imageNamed:@"video_default"];
    if(bgImage)
    {
        [bgImage drawInRect:self.bounds];
    }
}


@end
