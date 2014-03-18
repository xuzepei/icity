//
//  RCWeatherView.m
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCWeatherView.h"
#import "RCImageLoader.h"

@implementation RCWeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    self.item = nil;
    
    self.imageUrl0 = nil;
    self.imageUrl1 = nil;
    self.imageUrl2 = nil;
    
    self.image0 = nil;
    self.image1 = nil;
    self.image2 = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage* bg = [UIImage imageNamed:@"weather_bg"];
    if(bg)
    {
        [bg drawInRect:self.bounds];
    }
    
    if(nil == self.item)
        return;
    
    CGFloat offset_x = 6.0;
    
    if(self.image0)
    {
        [self.image0 drawInRect:CGRectMake(offset_x, (self.bounds.size.height - self.image0.size.height)/2.0, self.image0.size.width, self.image0.size.height)];
        
        offset_x += self.image0.size.width +6.0;
    }
    
    NSString* temp0 = [self.item objectForKey:@"tq_d1_min"];
    NSString* temp1 = [self.item objectForKey:@"tq_d1_max"];
    if([temp0 length] && [temp1 length])
    {
        NSString* temp = [NSString stringWithFormat:@"%@ ~ %@",temp0,temp1];
        [temp drawAtPoint:CGPointMake(offset_x, (self.bounds.size.height - 16)/2.0) withFont:[UIFont systemFontOfSize:16]];
    }
    
    
    offset_x = 180.0f;
    if(self.image1)
    {
        [self.image1 drawInRect:CGRectMake(offset_x, 6, 50, 30)];
    }
    
    temp0 = [self.item objectForKey:@"tq_d2_min"];
    temp1 = [self.item objectForKey:@"tq_d2_max"];
    if([temp0 length] && [temp1 length])
    {
        [@"明天" drawAtPoint:CGPointMake(offset_x + 16,self.bounds.size.height - 30) withFont:[UIFont systemFontOfSize:10]];
        
        NSString* temp = [NSString stringWithFormat:@"%@ ~ %@",temp0,temp1];
        [temp drawAtPoint:CGPointMake(offset_x,self.bounds.size.height - 16) withFont:[UIFont systemFontOfSize:10]];
    }
    
    
    offset_x = 250.0f;
    if(self.image2)
    {
        [self.image2 drawInRect:CGRectMake(offset_x, 6, 50, 30)];
    }
    
    temp0 = [self.item objectForKey:@"tq_d3_min"];
    temp1 = [self.item objectForKey:@"tq_d3_max"];
    if([temp0 length] && [temp1 length])
    {
        [@"后天" drawAtPoint:CGPointMake(offset_x + 16,self.bounds.size.height - 30) withFont:[UIFont systemFontOfSize:10]];
        
        NSString* temp = [NSString stringWithFormat:@"%@ ~ %@",temp0,temp1];
        [temp drawAtPoint:CGPointMake(offset_x,self.bounds.size.height - 16) withFont:[UIFont systemFontOfSize:10]];
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.imageUrl0 = [self.item objectForKey:@"tq_d1_pic"];
    UIImage* image0 = [RCTool getImageFromLocal:self.imageUrl0];
    if(image0)
        self.image0 = image0;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:self.imageUrl0
                                         delegate:self
                                            token:nil];
    }
    
    self.imageUrl1 = [self.item objectForKey:@"tq_d2_pic"];
    UIImage* image1 = [RCTool getImageFromLocal:self.imageUrl1];
    if(image1)
        self.image1 = image1;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:self.imageUrl1
                                         delegate:self
                                            token:nil];
    }
    
    self.imageUrl2 = [self.item objectForKey:@"tq_d3_pic"];
    UIImage* image2 = [RCTool getImageFromLocal:self.imageUrl2];
    if(image2)
        self.image2 = image2;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:self.imageUrl2
                                         delegate:self
                                            token:nil];
    }
    
    [self setNeedsDisplay];
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
	if([urlString isEqualToString: self.imageUrl0])
	{
		self.image0 = [RCTool getImageFromLocal:self.imageUrl0];
		[self setNeedsDisplay];
	}
    else if([urlString isEqualToString: self.imageUrl1])
	{
		self.image1 = [RCTool getImageFromLocal:self.imageUrl1];
		[self setNeedsDisplay];
	}
    else if([urlString isEqualToString: self.imageUrl2])
	{
		self.image2 = [RCTool getImageFromLocal:self.imageUrl2];
		[self setNeedsDisplay];
	}
}


@end
