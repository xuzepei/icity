//
//  RCIndexAdViewController.h
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@interface RCIndexAdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FGalleryViewControllerDelegate>

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSDictionary* content;
@property(nonatomic,retain)FGalleryViewController *galleryController;
@property(nonatomic,retain)NSMutableArray* itemArray;


- (void)updateContent:(NSDictionary *)item;
- (void)initTableView;

@end
