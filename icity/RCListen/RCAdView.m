//
//  RCAdView.m
//  RCFang
//
//  Created by xuzepei on 3/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCAdView.h"
#import "RCImageLoader.h"
#import "RCTool.h"

#define BAR_COLOR [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]

@implementation RCAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView* barView = [[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)] autorelease];
        barView.backgroundColor = BAR_COLOR;
        [self addSubview:barView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - 20, frame.size.width - 120, 20)];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.imageUrl = nil;
    self.image = nil;
    self.delegate = nil;
    self.textLabel = nil;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(self.image)
    {
        [self.image drawInRect:self.bounds];
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.image = nil;
    self.item = item;
    
    NSString* url = [item objectForKey:@"ip_picurl"];
    if(0 == [url length])
        url = [item objectForKey:@"img"];
    
    NSString* text = [item objectForKey:@"ip_desc"];
    if([text length])
    {
        _textLabel.text = text;
    }
    
    self.imageUrl = url;
    if([self.imageUrl length])
    {
        UIImage* image = [RCTool getImageFromLocal:self.imageUrl];
        if(image)
            self.image = image;
        else
        {
            [[RCImageLoader sharedInstance] saveImage:self.imageUrl
                                             delegate:self
                                                token:nil];
        }
    }
    
    
    [self setNeedsDisplay];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedAd:)])
    {
        [_delegate clickedAd:self.item];
    }
}


@end
