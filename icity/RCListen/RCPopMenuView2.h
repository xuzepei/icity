//
//  RCPopMenuView2.h
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPopMenuView2Delegate <NSObject>

- (void)clickedPopMenu2Item:(id)token;

@end

@interface RCPopMenuView2 : UIView

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSArray* itemArray;

- (void)updateContent;

@end
