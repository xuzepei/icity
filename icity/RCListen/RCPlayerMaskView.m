//
//  RCPlayerMaskView.m
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPlayerMaskView.h"

@implementation RCPlayerMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _videoIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _videoIndicator.hidesWhenStopped = YES;
        _videoIndicator.center = CGPointMake(126, 116);

        
        [self addSubview:_videoIndicator];
    }
    return self;
}

- (void)dealloc
{
    self.videoIndicator = nil;
    
    [super dealloc];
}


- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7] CGColor]);
    
    CGContextAddPath(ctx, clippath);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage* bgImage = [UIImage imageNamed:@"video_default"];
    if(bgImage)
    {
        [bgImage drawInRect:self.bounds];
    }
    
    CGRect tempRect = CGRectMake(110, 100, 100, 30);
    [self drawRoundRect:tempRect radius:5.0];
    
    
    [[UIColor whiteColor] set];
    NSString* temp = @"加载中...";
    [temp drawAtPoint:CGPointMake(138, 106) withFont:[UIFont systemFontOfSize:16]];
}


@end
