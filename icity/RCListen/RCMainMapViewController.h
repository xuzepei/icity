//
//  RCMainMapViewController.h
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMainTitleView.h"
#import "RCPopMenuView.h"
#import "RCBaiDuMapViewController.h"
#import "RCHttpRequest.h"

@interface RCMainMapViewController : RCBaiDuMapViewController

@property(nonatomic,retain)NSArray* titleMenuArray;
@property(nonatomic,retain)RCMainTitleView* titleView;
@property(nonatomic,retain)RCPopMenuView* popMenuView;
@property(nonatomic,retain)NSDictionary* current_jq;
@property(nonatomic,retain)NSMutableArray* pointArray;

@property(nonatomic,retain)UIStepper* stepper;
@property(nonatomic,retain)UIButton* gpsButton;

- (void)updateContent:(NSDictionary*)item titleMenu:(NSArray*)array;

@end
