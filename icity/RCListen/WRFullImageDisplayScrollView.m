//
//  WRFullImageDisplayView.m
//  WRadio
//
//  Created by xu zepei on 2/9/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import "WRFullImageDisplayScrollView.h"

@implementation WRFullImageDisplayScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(setNavigationBarHide)])
    {
        [(id<WRFullImageDisplayScrollViewDelegate>)(self.delegate) setNavigationBarHide];
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end
