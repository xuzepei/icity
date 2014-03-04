//
//  RCMainListCellContentView.m
//  iCity
//
//  Created by xuzepei on 3/3/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMainListCellContentView.h"
#import "RCImageLoader.h"

#define LINE_COLOR [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]

#define IMAGE_RECT_0 CGRectMake(8, 0, [RCTool getScreenSize].width - 16, 182)

@implementation RCMainListCellContentView

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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    
    if(self.image)
    {
        [self.image drawInRect:CGRectMake(0,4, self.bounds.size.width, 80)];
    }
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
