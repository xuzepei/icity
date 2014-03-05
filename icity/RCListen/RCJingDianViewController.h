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

@interface RCJingDianViewController : UIViewController

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSDictionary* content;
@property(nonatomic,retain)MPMoviePlayerController* videoPlayer;
@property(nonatomic,retain)UIActivityIndicatorView* videoIndicator;
@property(nonatomic,retain)IBOutlet UIScrollView* scrollView;
@property(nonatomic,retain)RCWeatherView* weatherView;
@property(nonatomic,retain)RCFunctionView* functionView;

- (void)updateContent:(NSDictionary*)item;

@end
