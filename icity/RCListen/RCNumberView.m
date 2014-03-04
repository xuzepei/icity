//
//  RCNumberView.m
//  RCFang
//
//  Created by xuzepei on 8/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCNumberView.h"

#define EDGE_INSETS UIEdgeInsetsMake(0, 10, 20, 11)

@implementation RCNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    
    NSString* temp = nil;
    if(self.number <= 99)
        temp = [NSString stringWithFormat:@"%d",self.number];
    else
        temp = @"99+";
    
    CGSize size = [temp sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage* bgImage = [UIImage imageNamed:@"yuan"];
    if(bgImage)
    {
        bgImage = [bgImage resizableImageWithCapInsets:EDGE_INSETS];
        [bgImage drawInRect:CGRectMake(0, 0, MAX(size.width + 11,24), self.bounds.size.height)];
    }
    
    CGRect tempRect = self.bounds;
    tempRect.origin.y = 2.0;
    tempRect.size.width = MAX(size.width + 11,24);
    [temp drawInRect:tempRect
                          withFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    

}


- (void)updateNumber:(int)number
{
    self.number = number;
    [self setNeedsDisplay];
}

@end
