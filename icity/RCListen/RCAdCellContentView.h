//
//  RCAdCellContentView.h
//  iCity
//
//  Created by xuzepei on 5/27/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPublicCellContentView.h"

@protocol RCAdCellContentViewDelegate <NSObject>

- (void)clickedCell:(id)token;

@end

@interface RCAdCellContentView : RCPublicCellContentView

- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token;

@end
