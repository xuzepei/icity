//
//  RCPickerView.h
//  RCFang
//
//  Created by xuzepei on 3/13/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPickerViewDelegate <NSObject>

- (void)clickedSureValueButton:(int)index token:(id)token;

@end

@interface RCPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(assign)id delegate;
@property(nonatomic,retain)UIPickerView* pickerView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)UIToolbar* toolbar;
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)UIView* protectView;
@property(nonatomic,retain)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;
- (void)show;
- (void)hide;

@end
