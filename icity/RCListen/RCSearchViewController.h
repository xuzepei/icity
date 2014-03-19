//
//  RCSearchViewController.h
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCSearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UISearchBar* searchBar;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UITableView* tableView;

@end
