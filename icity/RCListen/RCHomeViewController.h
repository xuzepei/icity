//
//  RCHomeViewController.h
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"


@interface RCHomeViewController : UIViewController<RCAdScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,RCAdScrollViewDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)RCAdScrollView* adScrollView;
@property(nonatomic,retain)UITableView* tableView;
@property(assign)int textIndex;
@property(assign)CGFloat adHeight;
@property(nonatomic,retain)NSDictionary* item;

- (void)initAdScrollView;
- (void)initTableView;

@end
