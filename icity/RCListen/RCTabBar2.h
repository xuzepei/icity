//
//  RCTabBar2.h
//  RCFang
//
//  Created by xuzepei on 8/28/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCTabBarDelegate <NSObject>

@optional
- (void)clickedTabItem:(int)index token:(id)token;

@end

@interface RCTabBar2 : UIView

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)id delegate;
@property(nonatomic,retain)UILabel* underlineView;

- (void)updateContent:(NSArray*)itemArray;


@end
