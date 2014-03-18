//
//  RCButtonView.m
//  RCFang
//
//  Created by xuzepei on 3/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCButtonView.h"

@implementation RCButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.image = [UIImage imageNamed:@"button_view_bg"];
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
    self.image = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void)updateContent:(NSString*)text
{
    self.text = text;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(_image)
    {
        [_image drawInRect:self.bounds];
    }
    
    [[UIColor blackColor] set];
    CGSize size = [_text drawInRect:CGRectMake(0,(self.bounds.size.height - 16)/2.0, self.bounds.size.width, self.bounds.size.height) withFont:[UIFont boldSystemFontOfSize:16]
        lineBreakMode:NSLineBreakByWordWrapping
            alignment:NSTextAlignmentCenter];
    
    UIImage* image = [UIImage imageNamed:@"arrow_down"];
    if(image)
    {
        [image drawAtPoint:CGPointMake(self.bounds.size.width /2.0 + size.width/2.0 +4.0, 20)];
    }
    

    if(0 == self.frame.origin.x)
    {
        [[UIColor grayColor] set];
        
        CGRect temp = CGRectMake(self.bounds.size.width - 2, 6, 2, self.bounds.size.height - 12);
        UIRectFill(temp);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //UITouch* touch = [touches anyObject];

    if(_delegate && [_delegate respondsToSelector:@selector(clickedHeaderButton:token:)])
    {
        [_delegate clickedHeaderButton:self.tag token:nil];
    }
}


@end
