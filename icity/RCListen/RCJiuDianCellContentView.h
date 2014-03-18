//
//  RCJiuDianCellContentView.h
//  iCity
//
//  Created by xuzepei on 3/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPublicCellContentView.h"

@protocol RCJiuDianCellContentViewDelegate <NSObject>

- (void)clickedCell:(id)token;
- (void)clickedLeftButton:(id)token;
- (void)clickedRightButton:(id)token;

@end

@interface RCJiuDianCellContentView : RCPublicCellContentView

- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token;

@end
