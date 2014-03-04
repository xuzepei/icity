//
//  RCShareTextViewController.h
//  RCFang
//
//  Created by xuzepei on 5/27/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCShareTextToolbar;
@interface RCShareTextViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,retain)UITextView* textView;
@property(assign)SHARE_TYPE shareType;
@property(nonatomic,retain)RCShareTextToolbar* toolbar;

- (void)updateContent:(SHARE_TYPE)shareType text:(NSString*)text;

@end
