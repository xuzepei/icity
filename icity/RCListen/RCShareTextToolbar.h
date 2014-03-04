//
//  RCShareTextToolbar.h
//  RCFang
//
//  Created by xuzepei on 6/5/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCShareTextToolbarDelegate <NSObject>

- (void)clickedClearButton:(id)token;

@end

@interface RCShareTextToolbar : UIView

@property(assign)int textCount;
@property(assign)id delegate;

- (void)updateTextCount:(int)count;

@end
