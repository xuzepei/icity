//
//  RCJingDianMapViewController.h
//  iCity
//
//  Created by xuzepei on 3/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBaiDuMapViewController.h"
#import "RCHttpRequest.h"

@interface RCJingDianMapViewController : RCBaiDuMapViewController

@property(nonatomic,retain)NSMutableArray* pointArray;
@property(nonatomic,retain)UIStepper* stepper;
@property(nonatomic,retain)UIButton* gpsButton;

- (void)updateContent:(NSArray *)itemArray title:(NSString*)title;

@end
