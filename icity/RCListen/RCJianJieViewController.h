//
//  RCJianJieViewController.h
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "iToast.h"
#import "iCitySDK.h"
#import "ShareEntity.h"

@interface RCJianJieViewController : UIViewController<UIActionSheetDelegate,UIWebViewDelegate,iCitySDKDelegate>

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSDictionary* token;
@property(nonatomic,retain)UIImageView* imageView;
@property(nonatomic,retain)UITextView* textView;
@property(nonatomic,retain)UIImage* image;

@property(nonatomic,retain)UIToolbar* toolbar;
@property(nonatomic,retain)UIBarButtonItem* shareItem;
@property(nonatomic,retain)UIBarButtonItem* favItem;
@property(assign)BOOL isFaved;

@property(nonatomic,retain)UIWebView* webView;
@property(nonatomic,retain)UIActivityIndicatorView* indicator;

@property(nonatomic,retain)IBOutlet UIView* shareView;
@property(nonatomic,retain)IBOutlet UIButton* cancelShareButton;


- (void)updateContent:(NSDictionary*)item token:(NSDictionary*)token;

@end
