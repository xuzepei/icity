//
//  RCJiuDianViewController.h
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"
#import "RCButtonView.h"

@interface RCJiuDianViewController : UIViewController


@property(nonatomic,retain)RCPickerView* pickerView;
@property(nonatomic,retain)NSDictionary* fanweiSelection;
@property(nonatomic,retain)NSDictionary* leibieSelection;
@property(nonatomic,retain)RCButtonView* headerButton0;
@property(nonatomic,retain)RCButtonView* headerButton1;

@end
