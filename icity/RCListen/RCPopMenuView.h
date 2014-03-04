//
//  RCPopMenuView.h
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPopMenuViewDelegate <NSObject>

- (void)clickedPopMenuItem:(id)token;

@end

@interface RCPopMenuView : UIView

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSArray* itemArray;

- (void)updateContent:(NSArray*)array;

@end
