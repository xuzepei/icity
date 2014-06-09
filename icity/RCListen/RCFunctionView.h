//
//  RCFunctionView.h
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCJDView.h"
#import "RCDHView.h"
#import "RCJiuDianView.h"

@protocol RCFunctionViewDelegate <NSObject>

- (void)clickedFunction:(int)index;

@end

@interface RCFunctionView : UIView

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)RCJDView* jdView;
@property(nonatomic,retain)RCDHView* dhView;
@property(nonatomic,retain)RCJiuDianView* jiuDianView;
@property(nonatomic,retain)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;

@end
