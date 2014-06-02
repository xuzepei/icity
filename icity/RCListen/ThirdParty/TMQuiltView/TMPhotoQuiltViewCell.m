//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"
#define OFFSET_HEIGHT 42.0f

const CGFloat kTMPhotoQuiltViewMargin = 6;

@implementation TMPhotoQuiltViewCell

@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc {
    [_photoView release], _photoView = nil;
    [_titleLabel release], _titleLabel = nil;
    
    self.shareButton = nil;
    self.zanButton = nil;
    self.zanLabel = nil;
    self.item = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = [UIImage imageNamed:@"fenxiang_button"];
        [self.shareButton setImage:image forState:UIControlStateNormal];
        self.shareButton.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - 34, image.size.width, image.size.height);
        [self.shareButton addTarget:self action:@selector(clickedShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareButton];
        
        self.zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 100 - kTMPhotoQuiltViewMargin, self.bounds.size.height - 20, 100, 20)];
        self.zanLabel.backgroundColor = [UIColor clearColor];
        self.zanLabel.font = [UIFont systemFontOfSize:12];
        self.zanLabel.textColor = [UIColor blackColor];
        self.zanLabel.textAlignment = NSTextAlignmentRight;
        self.zanLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.zanLabel.text = @"0";
        [self addSubview:self.zanLabel];
        
        self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        image = [UIImage imageNamed:@"zan_button"];
        [self.zanButton setImage:image forState:UIControlStateNormal];
        self.zanButton.frame = CGRectMake(self.bounds.size.width - 40 - kTMPhotoQuiltViewMargin, self.bounds.size.height - 32, image.size.width, image.size.height);
        [self.zanButton addTarget:self action:@selector(clickedZanButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.zanButton];
        
        [self updateContent:nil];
    }
    return self;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
    }
    return _photoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
    
- (void)layoutSubviews {
//    self.photoView.frame = CGRectInset(self.bounds, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//    self.titleLabel.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - 20 - kTMPhotoQuiltViewMargin,
//                                       self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin, 20);
    
    self.photoView.frame = CGRectMake(kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin, self.bounds.size.width - kTMPhotoQuiltViewMargin*2, self.bounds.size.height - kTMPhotoQuiltViewMargin*2 - OFFSET_HEIGHT);
    
    self.titleLabel.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - OFFSET_HEIGHT - kTMPhotoQuiltViewMargin,
                                       self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin, 20);
    
    CGRect rect = self.shareButton.frame;
    self.shareButton.frame = CGRectMake(kTMPhotoQuiltViewMargin + 2, self.bounds.size.height - 26, rect.size.width, rect.size.height);
    
    
    self.zanLabel.frame = CGRectMake(self.bounds.size.width - 100 - kTMPhotoQuiltViewMargin - 2, self.bounds.size.height - 26, 100, 20);
    
//    CGSize size = [self.zanLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 16) lineBreakMode:NSLineBreakByCharWrapping];
//    rect = self.zanButton.frame;
//    CGFloat offset_x = MAX(36.0,size.width);
//    self.zanButton.frame = CGRectMake(self.bounds.size.width - kTMPhotoQuiltViewMargin - offset_x, self.bounds.size.height - 22, rect.size.width, rect.size.height);
    
    NSString* zanNum = self.zanLabel.text;
    CGSize size = [zanNum sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 14) lineBreakMode:NSLineBreakByTruncatingTail];
    if(self.zanButton && [self.zanLabel.text length])
    {
//        CGPoint center = self.zanButton.center;
//        center.x = self.bounds.size.width - size.width - kTMPhotoQuiltViewMargin - 10;
//        self.zanButton.center = center;
        
        self.zanButton.frame = CGRectMake(self.bounds.size.width - kTMPhotoQuiltViewMargin - size.width - 12 - rect.size.width/2.0, self.bounds.size.height - 24, rect.size.width, rect.size.height);
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    NSString* zanNum = @"100";
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paragraphStyle.alignment = NSTextAlignmentRight;
//    
////    [zanNum drawInRect:CGRectMake(self.bounds.size.width - 100 - kTMPhotoQuiltViewMargin, self.bounds.size.height - 30, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle}];
//    
//    CGSize size = [zanNum drawInRect:CGRectMake(self.bounds.size.width - 100 - kTMPhotoQuiltViewMargin, self.bounds.size.height - 20, 100, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
//    if(self.zanButton)
//    {
//        CGPoint center = self.zanButton.center;
//        center.x = self.bounds.size.width - size.width - kTMPhotoQuiltViewMargin - 12;
//        self.zanButton.center = center;
//    }
//}

- (void)updateContent:(NSString*)zanNum
{
//    CGSize size = [zanNum sizeWithFont:[UIFont systemFontOfSize:12] forWidth:100 lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size = [zanNum sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 14) lineBreakMode:NSLineBreakByTruncatingTail];
    if(self.zanButton)
    {
        CGPoint center = self.zanButton.center;
        center.x = self.bounds.size.width - size.width - kTMPhotoQuiltViewMargin - 12;
        self.zanButton.center = center;
    }
}

- (void)clickedShareButton:(id)sender
{
    NSLog(@"clickedShareButton");
    
    if(self.item)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedShareButton:)])
        {
            [self.delegate clickedShareButton:nil];
        }
    }
}

- (void)clickedZanButton:(id)sender
{
    NSLog(@"clickedZanButton");
    
    if(self.item)
    {
        NSString* p_id = [self.item objectForKey:@"p_id"];
        NSArray* array = [self.item objectForKey:@"plist"];
        NSString* isLiked = @"0";
        
        NSNumber* isLikedNum = [self.item objectForKey:@"isLiked"];
        if(isLikedNum)
        {
            if([isLikedNum boolValue])
                isLiked = @"1";
        }
        else if(array && [array isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* temp in array)
            {
                NSString* temp_p_id = [temp objectForKey:@"p_id"];
                if([temp_p_id isEqualToString:p_id])
                {
                    isLiked = [temp objectForKey:@"p_likeflag"];
                    break;
                }
            }
        }
        
        if([isLiked isEqualToString:@"1"])
        {
            //取消赞
            if(self.delegate && [self.delegate respondsToSelector:@selector(clickedLikeButton:token:)])
            {
                [self.delegate clickedLikeButton:NO token:self.item];
            }
        }
        else
        {
            //点赞
            if(self.delegate && [self.delegate respondsToSelector:@selector(clickedLikeButton:token:)])
            {
                [self.delegate clickedLikeButton:YES token:self.item];
            }
        }
    }
}

@end
