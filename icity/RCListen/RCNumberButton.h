//
//  RCNumberButton.h
//  RCFang
//
//  Created by xuzepei on 8/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCNumberView.h"

@interface RCNumberButton : UIButton

@property(nonatomic,retain)RCNumberView* numberView;
@property(assign)int number;

- (void)updateNumber:(int)number;

@end
