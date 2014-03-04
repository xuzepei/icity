//
//  RCTabBar.h
//  RCFang
//
//  Created by xuzepei on 3/12/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCTabBarDelegate <NSObject>

@optional
- (void)clickedTabItem:(int)index token:(id)token;

@end

@interface RCTabBar : UIView

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)id delegate;
@property(nonatomic,retain)UIView* underlineView;

- (void)updateContent:(NSArray*)itemArray;

@end
