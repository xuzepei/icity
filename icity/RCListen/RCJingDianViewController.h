//
//  RCJingDianViewController.h
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RCWeatherView.h"
#import "RCFunctionView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "RCPlayerMaskView.h"
@interface RCJingDianViewController : UIViewController<UIActionSheetDelegate>

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSDictionary* content;
@property(nonatomic,retain)MPMoviePlayerController* videoPlayer;
@property(nonatomic,retain)UIActivityIndicatorView* videoIndicator;
@property(nonatomic,retain)IBOutlet UIScrollView* scrollView;
@property(nonatomic,retain)RCWeatherView* weatherView;
@property(nonatomic,retain)RCFunctionView* functionView;
@property(nonatomic,retain)UIToolbar* toolbar;
@property(nonatomic,retain)UIBarButtonItem* shareItem;
@property(nonatomic,retain)UIBarButtonItem* favItem;
@property(assign)BOOL isFaved;
@property(nonatomic,retain)RCPlayerMaskView* maskView;
@property(nonatomic,retain)UIButton* playButton;
@property(assign)BOOL isPlaying;
@property(assign)BOOL isLoading;

- (void)updateContent:(NSDictionary*)item;

@end
