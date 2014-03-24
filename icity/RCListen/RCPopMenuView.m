//
//  RCPopMenuView.m
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPopMenuView.h"

#define BG_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor blackColor]
#define ITEM_HEIGHT 30.0f

@implementation RCPopMenuView

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
        [arrow drawInRect:CGRectMake((self.bounds.size.width - arrow.size.width)/2.0, 0, arrow.size.width, arrow.size.height)];
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
    
    CGFloat offset_y = 10;
    for(NSDictionary* item in self.itemArray)
    {
        [TEXT_COLOR set];
        
        NSString* text = [item objectForKey:@"jq_name"];
        [text drawInRect:CGRectMake(3, offset_y + 5, self.bounds.size.width - 6, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        
        [[UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00] set];
        UIRectFill(CGRectMake(6, offset_y + 29, self.bounds.size.width -12, 1));
        
        offset_y += ITEM_HEIGHT;
    }
}

- (void)updateContent:(NSArray*)array
{
    self.itemArray = array;
    
    CGRect rect = self.frame;
    rect.size.height = [array count] * ITEM_HEIGHT + 30;
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
        //NSLog(@"index:%d",index);
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedPopMenuItem:)])
        {
            [self.delegate clickedPopMenuItem:index];
        }
    }
}

@end
