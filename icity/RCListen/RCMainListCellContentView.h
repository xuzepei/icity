//
//  RCMainListCellContentView.h
//  iCity
//
//  Created by xuzepei on 3/3/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCPublicCellContentView.h"

@protocol RCMainListCellContentViewDelegate <NSObject>

@optional
- (void)clickedCell:(id)token;

@end

@interface RCMainListCellContentView : RCPublicCellContentView

- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token;

@end
