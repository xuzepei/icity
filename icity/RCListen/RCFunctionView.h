//
//  RCFunctionView.h
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCFunctionViewDelegate <NSObject>

- (void)clickedFunction:(int)index;

@end

@interface RCFunctionView : UIView

@property(nonatomic,assign)id delegate;

@end
