//
//  RCDHView.m
//  iCity
//
//  Created by xuzepei on 5/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDHView.h"

#define BG_COLOR_1 [UIColor colorWithRed:143/255.0f green:202/255.0f blue:0/255.0f alpha:1.0]

#define BG_COLOR_2 [UIColor colorWithRed:0/255.0f green:221/255.0f blue:161/255.0f alpha:1.0]

#define BG_COLOR_6 [UIColor colorWithRed:255/255.0f green:186/255.0f blue:0/255.0f alpha:1.0]

#define BG_COLOR_7 [UIColor colorWithRed:255/255.0f green:50/255.0f blue:29/255.0f alpha:1.0]

@implementation RCDHView

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
    
    if(1 == self.type)
    {
        [BG_COLOR_1 set];
        UIRectFill(self.bounds);
        
        title = @"路径规划";
        subTitle = @"ROUTE";
        imageName = @"daohang_button";
    }
    else if(2 == self.type)
    {
        [BG_COLOR_2 set];
        UIRectFill(self.bounds);
        
        title = @"休闲娱乐";
        subTitle = @"LEISURE";
        imageName = @"yule_button";
    }
    else if(6 == self.type)
    {
        [BG_COLOR_6 set];
        UIRectFill(self.bounds);
        
        title = @"收藏";
        subTitle = @"SAVE";
        imageName = @"shoucang_button";
    }
    else if(7 == self.type)
    {
        [BG_COLOR_7 set];
        UIRectFill(self.bounds);
        
        title = @"分享";
        subTitle = @"SHARE";
        imageName = @"share_button";
    }
    
    if([imageName length])
    {
        UIImage* image= [UIImage imageNamed:imageName];
        if(image)
        {
            [image drawInRect:CGRectMake(6, (self.bounds.size.height - 40)/2.0, 40, 40)];
        }
    }
    
    [[UIColor whiteColor] set];
    [title drawInRect:CGRectMake(self.bounds.size.width - 208, self.bounds.size.height/2.0 - 18, 200, 20) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    [subTitle drawInRect:CGRectMake(self.bounds.size.width - 209, self.bounds.size.height/2.0 + 6, 200, 20) withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
}


@end
