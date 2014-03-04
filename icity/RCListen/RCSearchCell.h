//
//  RCSearchCell.h
//  RCFang
//
//  Created by xuzepei on 3/13/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCSearchCell : UITableViewCell

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UILabel* valueLabel;

- (void)updateContent:(NSDictionary*)item;

@end
