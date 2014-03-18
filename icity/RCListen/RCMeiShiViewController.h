//
//  RCMeiShiViewController.h
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCPickerView.h"
#import "RCButtonView.h"
#import "RCJingDianMapViewController.h"

@interface RCMeiShiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,retain)RCPickerView* pickerView;
@property(nonatomic,retain)NSDictionary* fanweiSelection;
@property(nonatomic,retain)NSDictionary* leibieSelection;
@property(nonatomic,retain)NSString* fanweiValue;
@property(nonatomic,retain)NSString* leibieValue;
@property(nonatomic,retain)RCButtonView* headerButton0;
@property(nonatomic,retain)RCButtonView* headerButton1;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(assign)int pageno;

- (void)updateContent:(NSDictionary*)item;

@end
