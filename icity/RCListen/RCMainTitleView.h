//
//  RCMainTitleView.h
//  iCity
//
//  Created by xuzepei on 3/3/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCMainTitleViewDelegate <NSObject>

- (void)clickedTitleView:(id)sender;

@end

@interface RCMainTitleView : UIView

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSString* text;

- (void)updateContent:(NSString*)text;

@end
