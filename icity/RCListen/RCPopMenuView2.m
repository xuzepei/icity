//
//  RCPopMenuView2.m
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPopMenuView2.h"

#define BG_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor blackColor]
#define ITEM_HEIGHT 30.0f

@implementation RCPopMenuView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.itemArray = nil;
    self.delegate = nil;
    
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    UIImage* arrow = [UIImage imageNamed:@"arrow_top"];
    if(arrow)
    {
        [arrow drawInRect:CGRectMake(self.bounds.size.width - 30, 0, arrow.size.width, arrow.size.height)];
    }
    
    CGRect temp = CGRectMake(4, 7, self.bounds.size.width - 8, self.bounds.size.height - 14);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:temp cornerRadius:7].CGPath;
    CGContextAddPath(ctx, clippath);
    CGContextClip(ctx);
    CGContextSetFillColorWithColor(ctx, BG_COLOR.CGColor);
    CGContextFillRect(ctx, temp);
    CGContextRestoreGState(ctx);
    
    CGFloat offset_y = 18;
    int i = 0;
    for(NSString* item in self.itemArray)
    {
        [TEXT_COLOR set];
        
        UIImage* image = nil;
        if(0 == i)
            image = [UIImage imageNamed:@"map_item"];
        else if(1 == i)
            image = [UIImage imageNamed:@"more_btn_search"];
        else if(2 == i)
            image = [UIImage imageNamed:@"more_btn_fav"];
        
        [image drawInRect:CGRectMake(16, offset_y, 18, 18)];
        
        NSString* text = item;
        [text drawInRect:CGRectMake(40, offset_y, self.bounds.size.width - 6, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        
        if(i < [self.itemArray count] - 1)
        {
            [[UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00] set];
            UIRectFill(CGRectMake(6, offset_y + 27, self.bounds.size.width -12, 1));
        }
        
        i++;
        offset_y += ITEM_HEIGHT + 8;
    }
}

- (void)updateContent
{
    self.itemArray = [NSArray arrayWithObjects:@"地图",@"搜索",@"收藏夹",nil];
    
    CGRect rect = self.frame;
    rect.size.height = [self.itemArray count] * ITEM_HEIGHT + 36;
    self.frame = rect;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    CGFloat y = touchPoint.y - 10;
    if(y > 0)
    {
        int index = floor(y/ITEM_HEIGHT);
        NSLog(@"index:%d",index);
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedPopMenu2Item:)])
        {
            [self.delegate clickedPopMenu2Item:index];
        }
    }
}

@end
