//
//  RCJianJieViewController.h
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCJianJieViewController : UIViewController

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)IBOutlet UIImageView* imageView;
@property(nonatomic,retain)IBOutlet UITextView* textView;
@property(nonatomic,retain)UIImage* image;

- (void)updateContent:(NSDictionary*)item;

@end
