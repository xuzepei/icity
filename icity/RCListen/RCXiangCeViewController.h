//
//  RCXiangCeViewController.h
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "FGalleryViewController.h"
#import "iCitySDK.h"
#import "ShareEntity.h"

@interface RCXiangCeViewController : UIViewController<TMQuiltViewDataSource,TMQuiltViewDelegate,FGalleryViewControllerDelegate,iCitySDKDelegate>

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSString* pid;
@property(nonatomic,retain)TMQuiltView *waterfallView;
@property(assign)BOOL isLoading;
@property(nonatomic,retain)FGalleryViewController *galleryController;
@property(nonatomic,retain)NSMutableArray* imageArray;

@property(nonatomic,retain)NSDictionary* willReplaceItem;

@property(nonatomic,retain)IBOutlet UIView* shareView;
@property(nonatomic,retain)IBOutlet UIButton* cancelShareButton;

- (void)updateContent:(NSDictionary*)item;

@end
