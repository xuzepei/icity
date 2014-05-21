//
//  RCJDView.m
//  iCity
//
//  Created by xuzepei on 5/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJDView.h"
#import "RCImageLoader.h"

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

- (void)dealloc
{
    self.image = nil;
    self.imageUrl = nil;
    
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString* title = @"";
    NSString* subTitle = @"";
    NSString* imageName = @"";
    
    if(0 == self.type)
    {
        title = @"景点简介";
        subTitle = @"SCENIC SPOTS";
        imageName = @"fengjing_default";
    }
    else if(4 == self.type)
    {
        title = @"美食推荐";
        subTitle = @"FOOD";
        imageName = @"meishi_default";
    }
    else if(5 == self.type)
    {
        title = @"相册";
        subTitle = @"PHOTO";
        imageName = @"xiangce_default";
    }
    
    UIImage* image = nil;
    if([self.imageUrl length])
    {
        image = [RCTool getImageFromLocal:self.imageUrl];
    }
    
    if(nil == image)
    {
        image = [UIImage imageNamed:imageName];
    }
    
    if(image)
    {
        [image drawInRect:self.bounds];
    }
    
    [[UIColor whiteColor] set];
    [title drawInRect:CGRectMake(self.bounds.size.width - 208, self.bounds.size.height - 52, 200, 20) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    [subTitle drawInRect:CGRectMake(self.bounds.size.width - 210, self.bounds.size.height - 28, 200, 20) withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    

}


- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
	if([urlString isEqualToString: self.imageUrl])
	{
		//self.image = [RCTool getImageFromLocal:self.imageUrl];
		[self setNeedsDisplay];
	}
}

@end
