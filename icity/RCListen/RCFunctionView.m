//
//  RCFunctionView.m
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCFunctionView.h"

#define RECT0 CGRectMake(0,4,186,138)
#define RECT1 CGRectMake(190,4,130,67)
#define RECT2 CGRectMake(190,75,130,67)
#define RECT3 CGRectMake(0,146,128,137)
#define RECT4 CGRectMake(132,146,188,137)
#define RECT5 CGRectMake(0,287,170,138)
#define RECT6 CGRectMake(174,287,146,67)
#define RECT7 CGRectMake(174,358,146,67)

#define OFFSET_VALUE 4.0f

@implementation RCFunctionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        
        RCJDView* view0 = [[[RCJDView alloc] initWithFrame:RECT0] autorelease];
        view0.tag = 100+0;
        view0.type = 0;
        [self addSubview:view0];
        
        
        RCDHView* view1 = [[[RCDHView alloc] initWithFrame:RECT1] autorelease];
        view1.type = 1;
        [self addSubview:view1];
        
        RCDHView* view2 = [[[RCDHView alloc] initWithFrame:RECT2] autorelease];
        view2.type = 2;
        [self addSubview:view2];
        
        RCJiuDianView* view3 = [[[RCJiuDianView alloc] initWithFrame:RECT3] autorelease];
        view3.type = 3;
        [self addSubview:view3];
        
        RCJDView* view4 = [[[RCJDView alloc] initWithFrame:RECT4] autorelease];
        view4.type = 4;
        view4.tag = 100+4;
        [self addSubview:view4];
        
        RCJDView* view5 = [[[RCJDView alloc] initWithFrame:RECT5] autorelease];
        view5.type = 5;
        view5.tag = 100+5;
        [self addSubview:view5];
        
        RCDHView* view6 = [[[RCDHView alloc] initWithFrame:RECT6] autorelease];
        view6.type = 6;
        [self addSubview:view6];
        
        RCDHView* view7 = [[[RCDHView alloc] initWithFrame:RECT7] autorelease];
        view7.type = 7;
        [self addSubview:view7];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.jdView = nil;
    self.jiuDianView = nil;
    self.dhView = nil;
    self.item = nil;
    
    [super dealloc];
}

- (void)updateContent:(NSDictionary *)item
{
    self.item = item;
    
    RCJDView* view0 = (RCJDView*)[self viewWithTag:100 + 0];
    if(self.item)
    {
        view0.imageUrl = [self.item objectForKey:@"jd_picurl_jdjj"];
        [view0 setNeedsDisplay];
    }
    
    RCJDView* view4 = (RCJDView*)[self viewWithTag:100 + 4];
    if(self.item)
    {
        view4.imageUrl = [self.item objectForKey:@"jd_picurl_mstj"];
        [view4 setNeedsDisplay];
    }
    
    RCJDView* view5 = (RCJDView*)[self viewWithTag:100 + 5];
    if(self.item)
    {
        view5.imageUrl = [self.item objectForKey:@"jd_picurl_xc"];
        [view5 setNeedsDisplay];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    UIImage* bg = [UIImage imageNamed:@"function_bg"];
//    if(bg)
//    {
//        [bg drawInRect:self.bounds];
//    }
//}

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
    else if(CGRectContainsPoint(RECT5, point))
    {
        index = 5;
    }
    else if(CGRectContainsPoint(RECT6, point))
    {
        index = 6;
    }
    else if(CGRectContainsPoint(RECT7, point))
    {
        index = 7;
    }
    
    if(-1 == index)
        return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedFunction:)])
    {
        [self.delegate clickedFunction:index];
    }
}


@end
