//
//  RCPlaceHolderTextView.h
//  RCFang
//
//  Created by xuzepei on 5/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
	
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;


@end
