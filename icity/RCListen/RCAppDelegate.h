//
//  RCAppDelegate.h
//  RCFang
//
//  Created by xuzepei on 1/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BMapKit.h"

@interface RCAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    UIBackgroundTaskIdentifier _bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain)RCMainViewController* mainViewController;

@property (nonatomic,retain)UINavigationController* mainNavigationController;

@property(nonatomic,retain)BMKMapManager* mapManager;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
