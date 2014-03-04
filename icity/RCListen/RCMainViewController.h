//
//  RCMainViewController.h
//  iCity
//
//  Created by xuzepei on 3/4/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"
#import "RCMainTitleView.h"
#import "RCPopMenuView.h"
#import "RCMainMapViewController.h"

@interface RCMainViewController : UITableViewController<RCAdScrollViewDelegate,UIAlertViewDelegate,
RCMainTitleViewDelegate,RCPopMenuViewDelegate>
{
}

@property(nonatomic,retain)RCAdScrollView* adScrollView;
//@property(nonatomic,retain)UITableView* tableView;
@property(assign)int textIndex;
@property(assign)CGFloat adHeight;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSMutableArray* adArray;
@property(nonatomic,retain)NSDictionary* current_jq;
@property(nonatomic,retain)RCMainTitleView* titleView;
@property(nonatomic,retain)RCPopMenuView* popMenuView;
@property(nonatomic,retain)NSMutableArray* titleMenuArray;

- (void)initAdScrollView;

@end
