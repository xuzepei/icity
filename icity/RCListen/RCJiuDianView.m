//
//  RCJiuDianView.m
//  iCity
//
//  Created by xuzepei on 5/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#define BG_COLOR_3 [UIColor colorWithRed:8/255.0f green:171/255.0f blue:255/255.0f alpha:1.0]

#import "RCJiuDianView.h"

@implementation RCJiuDianView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.type = -1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString* title = @"";
    NSString* subTitle = @"";
    NSString* imageName = @"";
    
    if(3 == self.type)
    {
        [BG_COLOR_3 set];
        UIRectFill(self.bounds);
        
        title = @"酒店";
        subTitle = @"HOTEL";
        imageName = @"jiudian_button";
    }
    
    if([imageName length])
    {
        UIImage* image= [UIImage imageNamed:imageName];
        if(image)
        {
            [image drawInRect:CGRectMake(12, 16, 40, 40)];
        }
    }
    
    [[UIColor whiteColor] set];
    [title drawInRect:CGRectMake(self.bounds.size.width - 208, self.bounds.size.height - 52, 200, 20) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    [subTitle drawInRect:CGRectMake(self.bounds.size.width - 208, self.bounds.size.height - 28, 200, 20) withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
}


@end
