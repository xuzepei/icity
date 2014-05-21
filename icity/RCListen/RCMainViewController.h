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
#import "RCPopMenuView2.h"
#import "RCMainMapViewController.h"
#import "AdwoAdSDK.h"

@interface RCMainViewController : UIViewController<RCAdScrollViewDelegate,UIAlertViewDelegate,
RCMainTitleViewDelegate,RCPopMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,AWAdViewDelegate
>
{
}

@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(assign)int textIndex;
@property(assign)CGFloat adHeight;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSMutableArray* adArray;
@property(nonatomic,retain)NSDictionary* current_jq;
@property(nonatomic,retain)RCMainTitleView* titleView;
@property(nonatomic,retain)RCPopMenuView* popMenuView;
@property(nonatomic,retain)RCPopMenuView2* popMenuView2;
@property(nonatomic,retain)NSMutableArray* titleMenuArray;
@property(nonatomic,retain)UIView* adView;

- (void)initAdScrollView;

@end
