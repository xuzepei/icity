//
//  RCJDView.m
//  iCity
//
//  Created by xuzepei on 5/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJDView.h"

@implementation RCJDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor redColor];
        
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
    
    if(0 == self.type)
    {
        title = @"景点简介";
        subTitle = @"SCENIC SPOTS";
    }
    else if(4 == self.type)
    {
        title = @"美食推荐";
        subTitle = @"FOOD";
    }
    else if(5 == self.type)
    {
        title = @"相册";
        subTitle = @"PHOTO";
    }
    
    [[UIColor whiteColor] set];
    [title drawInRect:CGRectMake(self.bounds.size.width - 208, self.bounds.size.height - 52, 200, 20) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    [subTitle drawInRect:CGRectMake(self.bounds.size.width - 210, self.bounds.size.height - 28, 200, 20) withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
}


@end
