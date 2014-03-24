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

#define COLOR_0 [UIColor colorWithRed:235/255.0 green:126/255.0 blue:97/255.0 alpha:1.0]
#define COLOR_1 [UIColor colorWithRed:236/255.0 green:200/255.0 blue:94/255.0 alpha:1.0]
#define COLOR_2 [UIColor colorWithRed:0/255.0 green:153/255.0 blue:68/255.0 alpha:1.0]
#define COLOR_3 [UIColor colorWithRed:12/255.0 green:199/255.0 blue:180/255.0 alpha:1.0]
#define COLOR_4 [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0]

#define AREA_WIDTH  100.0f

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
    
    int index = [[self.token objectForKey:@"index"] intValue];
    int tempIndex = index % 5;
    
    BOOL isLeft = YES;
    int image_index = 1;
    if(index & 1)
    {
        isLeft = NO;
        image_index = 0;
    }
    
    CGRect tempRect = CGRectMake(0, 4, AREA_WIDTH, self.bounds.size.height - 4);
    if(NO == isLeft)
    {
        tempRect.origin.x = self.bounds.size.width - AREA_WIDTH;
        
        if(self.image)
        {
            [self.image drawInRect:CGRectMake(0,4, self.bounds.size.width - AREA_WIDTH, self.bounds.size.height - 4)];
        }
    }
    else
    {
        if(self.image)
        {
            [self.image drawInRect:CGRectMake(AREA_WIDTH,4, self.bounds.size.width - AREA_WIDTH, self.bounds.size.height - 4)];
        }
    }
    
    NSString* imageName = [NSString stringWithFormat:@"%d_%d",tempIndex,image_index];
    
    UIImage* arrowImage = [UIImage imageNamed:imageName];
    if(arrowImage)
    {
        if(isLeft)
        {
            [arrowImage drawAtPoint:CGPointMake(AREA_WIDTH, 38)];
        }
        else
        {
             [arrowImage drawAtPoint:CGPointMake(self.bounds.size.width - AREA_WIDTH - arrowImage.size.width, 38)];
        }
    }
    

    if(0 == tempIndex)
    {
        [COLOR_0 set];
    }
    else if(1 == tempIndex)
    {
        [COLOR_1 set];
    }
    else if(2 == tempIndex)
    {
        [COLOR_2 set];
    }
    else if(3 == tempIndex)
    {
        [COLOR_3 set];
    }
    else if(4 == tempIndex)
    {
        [COLOR_4 set];
    }
    
    UIRectFill(tempRect);
    
    [[UIColor whiteColor] set];
    NSString* jd_name = [self.item objectForKey:@"jd_name"];
    if([jd_name length])
    {
        [jd_name drawInRect:CGRectMake(tempRect.origin.x+2, tempRect.origin.y + 16, tempRect.size.width - 4, 20) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    }
    
    NSString* jd_title = [self.item objectForKey:@"jd_title"];
    if([jd_title length])
    {
        [jd_title drawInRect:CGRectMake(tempRect.origin.x + 2, tempRect.origin.y + 36, tempRect.size.width -4, 50)  withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
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
