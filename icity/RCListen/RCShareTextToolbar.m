//
//  RCShareTextToolbar.m
//  RCFang
//
//  Created by xuzepei on 6/5/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCShareTextToolbar.h"
#import "RCTool.h"

@implementation RCShareTextToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateTextCount:(int)count
{
    self.textCount = count;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //画数字
    NSString* textCount = nil;
    int number = 140 - _textCount;
    
    if(number < -1000)
        textCount = @"-1000+";
    else
        textCount = [NSString stringWithFormat:@"%d",number];
    
    CGFloat offset_x = 0;
    if([textCount length])
    {
        if(number < 0)
            [[UIColor orangeColor] set];
        else
            [[UIColor blackColor] set];
        
        CGSize size = [textCount sizeWithFont:[UIFont systemFontOfSize:18]
                            constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
        
        offset_x = [RCTool getScreenSize].width - 20 - size.width;
        
        [textCount drawInRect:CGRectMake(offset_x, 6, size.width, 20) withFont:[UIFont systemFontOfSize:18]];
    }
    
    if(number != 140)
    {
        UIImage* clearImage = [UIImage imageNamed:@"clear_button"];
        if(clearImage)
        {
            offset_x = [RCTool getScreenSize].width - 8 - clearImage.size.width;
            [clearImage drawAtPoint:CGPointMake(offset_x, 12)];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
	UITouch *touch = [touches anyObject];
	CGPoint endPoint = [touch locationInView: self];
    
    CGRect clearButtonRect = CGRectMake(self.bounds.size.width - 40, 0, 40, self.bounds.size.height);

    if(CGRectContainsPoint(clearButtonRect,endPoint) && _textCount)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(clickedClearButton:)])
        {
            [_delegate clickedClearButton: nil];
        }
    }
}



@end
