//
//  WRMessageImageDisplayView.h
//  WRadio
//
//  Created by xu zepei on 2/8/12.
//  Copyright (c) 2012 rumtel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WRMessageImageDisplayViewDelegate <NSObject>
@optional
- (void)displayFullImage:(NSString*)imageUrl;
@end

@interface WRMessageImageDisplayView : UIView
{
    NSDictionary* _dict;
    UIButton* _displayButton;
    UIActivityIndicatorView* _indicatorView;
    UIImageView* _imageView;
    NSString* _imageUrl;
    id<WRMessageImageDisplayViewDelegate> _delegate;
}

@property(nonatomic,retain)NSDictionary* _dict;
@property(nonatomic,retain)UIButton* _displayButton;
@property(nonatomic,retain)UIActivityIndicatorView* _indicatorView;
@property(nonatomic,retain)UIImageView* _imageView;
@property(nonatomic,retain)NSString* _imageUrl;
@property(nonatomic,assign)id<WRMessageImageDisplayViewDelegate> _delegate;

- (void)updateContent:(NSDictionary*)dict;
- (void)displayView;
- (void)closeView;

@end


