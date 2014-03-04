//
//  RCIndexAdCell2.h
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLinkButton.h"

@interface RCIndexAdCell2 : UITableViewCell

@property(nonatomic,retain)RCLinkButton* linkButton;
@property(assign)id delegate;
@property(nonatomic,retain)UITextView* textView;

- (void)updateContent:(NSString*)content height:(CGFloat)height delegate:(id)delegate;

@end
