//
//  RCFunctionView.m
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCFunctionView.h"

#define RECT0 CGRectMake(0,8/2.0,340/2.0,300/2.0)
#define RECT1 CGRectMake(350/2.0,8/2.0,193/2.0,150/2.0)
#define RECT2 CGRectMake(350/2.0,173/2.0,193/2.0,130/2.0)
#define RECT3 CGRectMake(0,312/2.0,340/2.0,210/2.0)
#define RECT4 CGRectMake(350/2.0,312/2.0,193/2.0,210/2.0)


@implementation RCFunctionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage* bg = [UIImage imageNamed:@"function_bg"];
    if(bg)
    {
        [bg drawInRect:self.bounds];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int index = -1;
    if(CGRectContainsPoint(RECT0, point))
    {
        index = 0;
    }
    else if(CGRectContainsPoint(RECT1, point))
    {
        index = 1;
    }
    else if(CGRectContainsPoint(RECT2, point))
    {
        index = 2;
    }
    else if(CGRectContainsPoint(RECT3, point))
    {
        index = 3;
    }
    else if(CGRectContainsPoint(RECT4, point))
    {
        index = 4;
    }
    
    if(-1 == index)
        return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedFunction:)])
    {
        [self.delegate clickedFunction:index];
    }
}


@end
