//
//  RCLinkButton.m
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCLinkButton.h"

@implementation RCLinkButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleLabel.textColor = [UIColor blueColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius
{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] CGColor]);
    
    CGContextAddPath(ctx, clippath);
    CGContextFillPath(ctx);

    CGContextRestoreGState(ctx);

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(self.isTouchDown)
    {
        CGRect temp = self.bounds;
        NSString* text = self.titleLabel.text;
        UIFont* font = self.titleLabel.font;
        
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height)];
        temp.size.width = size.width + 4.0;
        [self drawRoundRect:temp radius:2.0];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"touchesBegan:%s",__FILE__);
    
    self.isTouchDown = YES;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.isTouchDown = NO;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.isTouchDown = NO;
    [self setNeedsDisplay];
}

@end
