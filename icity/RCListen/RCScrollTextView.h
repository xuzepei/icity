//
//  RCScrollTextView.h
//  RCFang
//
//  Created by xuzepei on 8/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCyclingLabel.h"

@protocol RCScrollTextViewDelegate <NSObject>

- (void)scrollToEnd:(id)token;
- (void)clickedText:(id)token;

@end

@interface RCScrollTextView : UIView

@property(nonatomic,retain)NSMutableArray* textArray;
@property(nonatomic,retain)BBCyclingLabel* scrollLabel;
@property(assign)int showIndex;
@property(assign)id delegate;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSTimer* timer;

- (void)updateContent:(NSDictionary*)item;

@end
