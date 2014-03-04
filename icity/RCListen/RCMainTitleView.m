//
//  RCMainTitleView.m
//  iCity
//
//  Created by xuzepei on 3/3/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMainTitleView.h"

@implementation RCMainTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    // Drawing code
    if([self.text length])
    {
        [[UIColor blackColor] set];
        CGSize size = [self.text drawInRect:CGRectMake(0, 8, self.bounds.size.width, self.bounds.size.height) withFont:[UIFont systemFontOfSize:22] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        UIImage* image = [UIImage imageNamed:@"arrow_down"];
        if(image)
            [image drawAtPoint:CGPointMake(self.bounds.size.width/2.0 + size.width/2.0 + 8, self.bounds.size.height/2.0)];
    }
}

- (void)updateContent:(NSString*)text
{
    self.text = text;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedTitleView:)])
    {
        [self.delegate clickedTitleView:nil];
    }
}


@end
