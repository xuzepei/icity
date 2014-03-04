//
//  RCWebViewController.h
//  RCFang
//
//  Created by xuzepei on 4/4/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCWebViewController : UIViewController<UIWebViewDelegate>


@property(nonatomic,retain)NSString* urlString;
@property(nonatomic,retain)UIWebView* webView;
@property(nonatomic,retain)UIActivityIndicatorView* indicator;
@property(nonatomic,retain)UIToolbar* toolbar;
@property(nonatomic,retain)UIBarButtonItem* backwardItem;
@property(nonatomic,retain)UIBarButtonItem* forwardItem;
@property(nonatomic,assign)BOOL hideToolbar;


- (id)init:(BOOL)hideToolbar;
- (void)initToolbar;
- (void)initWebView;
- (void)updateContent:(NSString *)urlString title:(NSString*)title;
- (void)updateToolbarItem;

@end
