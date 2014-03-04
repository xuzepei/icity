//
//  RCTabBar2.m
//  RCFang
//
//  Created by xuzepei on 8/28/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCTabBar2.h"

#define RECT_0 CGRectMake(10,12,100,40)
#define RECT_1 CGRectMake(10+100,12,100,40)
#define RECT_2 CGRectMake(10+100*2,12,100,40)

#define UNDER_LINE_COLOR [UIColor colorWithRed:0.03 green:0.51 blue:1.00 alpha:1.00]

@implementation RCTabBar2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _itemArray = [[NSMutableArray alloc] init];
        
        _underlineView = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 36)];
        _underlineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"underline_bg"]];
        _underlineView.textColor = [UIColor whiteColor];
        _underlineView.font = [UIFont boldSystemFontOfSize:15];
        _underlineView.textAlignment = NSTextAlignmentCenter;
        [self addSubview: _underlineView];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    return self;
}

- (void)dealloc
{
    self.itemArray = nil;
    self.delegate = nil;
    self.underlineView = nil;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if([_itemArray count] < 3)
        return;
    
    [[UIColor blackColor] set];
    NSString* temp = [_itemArray objectAtIndex:0];
    [temp drawInRect:RECT_0 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:1];
    [temp drawInRect:RECT_1 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:2];
    [temp drawInRect:RECT_2 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}


- (void)updateContent:(NSArray*)itemArray
{
    [_itemArray removeAllObjects];
    [_itemArray addObjectsFromArray:itemArray];
    _underlineView.text = [_itemArray objectAtIndex:0];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block int index = -1;
    CGRect toRect = CGRectZero;
    if(CGRectContainsPoint(RECT_0, point))
    {
        index = 0;
        toRect = RECT_0;
    }
    else if(CGRectContainsPoint(RECT_1, point))
    {
        index = 1;
        toRect = RECT_1;
    }
    else if(CGRectContainsPoint(RECT_2, point))
    {
        index = 2;
        toRect = RECT_2;
    }
    
    if(toRect.origin.x)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             
                             CGRect rect = _underlineView.frame;
                             rect.origin.x = toRect.origin.x;
                             _underlineView.frame = rect;
                         }completion:^(BOOL finished) {
                             
                             if(index != -1 && index < [_itemArray count])
                             {
                                 _underlineView.text = [_itemArray objectAtIndex:index];
                             }
                         }];
    }
    
    if(-1 != index)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedTabItem:token:)])
        {
            [self.delegate clickedTabItem:index token:nil];
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end
