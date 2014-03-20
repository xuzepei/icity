//
//  RCUploadPhotoViewController.h
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPlaceHolderTextView.h"

@interface RCUploadPhotoViewController : UIViewController<UIActionSheetDelegate,UITextViewDelegate>

@property(nonatomic,retain)RCPlaceHolderTextView* textview;
@property(nonatomic,retain)UIButton* addButton;
@property(nonatomic,retain)NSMutableArray* imageArray;
@property(nonatomic,retain)NSMutableArray* imageUrlArray;
@property(nonatomic,retain)NSMutableArray* imageViewArray;
@property(assign)NSTimeInterval time;
@property(nonatomic,retain)NSString* jqid;
@property(assign)BOOL isUploading;


- (IBAction)clickedAddButton:(id)sender;

@end
