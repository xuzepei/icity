//
//  RCMeiShiCellContentView.m
//  iCity
//
//  Created by xuzepei on 3/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeiShiCellContentView.h"
#import "RCImageLoader.h"

#define LINE_COLOR [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]

#define IMAGE_RECT_0 CGRectMake(8, 0, [RCTool getScreenSize].width - 16, 182)

#define LEFT_BUTTON_RECT CGRectMake(10,90,150,30)
#define RIGHT_BUTTON_RECT CGRectMake(160,90,150,30)

@implementation RCMeiShiCellContentView

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
    [super dealloc];
}

- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    
    CGContextAddPath(ctx, clippath);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect temp = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 10);
    [self drawRoundRect:temp radius:10];
    
    
    CGFloat offset_x = 20;
    CGFloat offset_y = 20;
    NSString* name = [self.item objectForKey:@"name"];
    if([name length])
    {
        [[UIColor blackColor] set];
        [name drawInRect:CGRectMake(offset_x, offset_y, 200, 20) withFont:[UIFont boldSystemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    CGFloat juli = [[self.item objectForKey:@"juli"] floatValue];
    if(juli)
    {
        [[UIColor grayColor] set];
        NSString* temp = [NSString stringWithFormat:@"%.f米",juli];
        [temp drawInRect:CGRectMake(220, offset_y, 80, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentRight];
    }
    
    offset_y += 30.0f;
    
    NSString* pingfen = [self.item objectForKey:@"pingfen"];
    if([pingfen isKindOfClass:[NSNumber class]])
        pingfen = [NSString stringWithFormat:@"%.f",[pingfen floatValue]];
    
    if(0 == [pingfen length])
        pingfen = @"无";
    
    {
        [[UIColor blackColor] set];
        CGSize size = [@"好评度: " drawInRect:CGRectMake(offset_x,offset_y, 100, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail
                                 alignment:NSTextAlignmentLeft];
        offset_x += size.width;
        
        [[UIColor orangeColor] set];
        [pingfen drawInRect:CGRectMake(offset_x, offset_y, 100, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentLeft];
    }
    
    
    offset_x = 170;
    [[UIColor blackColor] set];
    CGSize size = [@"人均: " drawInRect:CGRectMake(offset_x,offset_y, 100, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail
                             alignment:NSTextAlignmentLeft];
    
    NSString* price = [self.item objectForKey:@"price"];
    if([price isKindOfClass:[NSNumber class]])
        price = [NSString stringWithFormat:@"%.f",[price floatValue]];
    
    if(0 == [price length])
        price = @"无";
    else
        price = [NSString stringWithFormat:@"¥%@",price];

    offset_x += size.width;
    
    [[UIColor orangeColor] set];
    [price drawInRect:CGRectMake(offset_x, offset_y, 100, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail
            alignment:NSTextAlignmentLeft];
    
    offset_y = 80;
    [[UIColor grayColor] set];
    CGRect lineRect = CGRectMake(20, offset_y, 280, 1);
    UIRectFill(lineRect);
    
    CGRect lineRect2 = CGRectMake(160, 85, 1, 30);
    UIRectFill(lineRect2);
    
    UIImage* image = [UIImage imageNamed:@"btn_here"];
    [image drawAtPoint:CGPointMake(80, 94)];
    
    image = [UIImage imageNamed:@"btn_call"];
    [image drawAtPoint:CGPointMake(230, 94)];
    
    
}


- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token
{
    self.item = item;
    self.delegate = delegate;
    self.token = token;
    
    self.imageUrl = [self.item objectForKey:@"jd_title_pic"];
    UIImage* image = [RCTool getImageFromLocal:self.imageUrl];
    if(image)
        self.image = image;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:self.imageUrl
                                         delegate:self
                                            token:nil];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(LEFT_BUTTON_RECT, point))
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedLeftButton:)])
        {
            [self.delegate clickedLeftButton:self.item];
        }
    }
    else if(CGRectContainsPoint(RIGHT_BUTTON_RECT, point))
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedRightButton:)])
        {
            [self.delegate clickedRightButton:self.item];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedCell:)])
        {
            [self.delegate clickedCell:self.item];
        }
    }
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
	if([urlString isEqualToString: self.imageUrl])
	{
		self.image = [RCTool getImageFromLocal:self.imageUrl];
		[self setNeedsDisplay];
	}
}

@end
