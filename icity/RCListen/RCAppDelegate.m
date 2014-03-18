//
//  RCAppDelegate.m
//  RCFang
//
//  Created by xuzepei on 1/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCTool.h"
#import "RCHttpRequest.h"

#define UPDATE_TAG 122

@implementation RCAppDelegate

- (void)dealloc
{
    self.mapManager = nil;
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    
    self.mainViewController = nil;
    self.mainNavigationController = nil;
    
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    UIApplication* app = [UIApplication sharedApplication];
	app.applicationIconBadgeNumber = 0;
	[app registerForRemoteNotificationTypes:
	 (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //导航条颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //homepage
    _mainViewController = [[RCMainViewController alloc] initWithStyle:UITableViewStylePlain];
	
	_mainNavigationController = [[UINavigationController alloc]
                                 initWithRootViewController:_mainViewController];
    
    self.window.rootViewController = _mainNavigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//       //首页广告
//       NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&pwd=%@&type=open",BASE_URL,APIID,PWD];
//    
//       RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
//       [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
//    
//       //获取区域和类型
////       urlString = [NSString stringWithFormat:@"%@/xinfang_search.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
////    
////       temp = [[[RCHttpRequest alloc] init] autorelease];
////       [temp request:urlString delegate:self resultSelector:@selector(finishedAreaRequest:) token:nil];
//    
//    //开关
//    urlString = [NSString stringWithFormat:@"%@/ios_test.php?apiid=%@&pwd=%@&version=%@",BASE_URL,APIID,PWD,VERSION];
//
//       temp = [[[RCHttpRequest alloc] init] autorelease];
//       [temp request:urlString delegate:self resultSelector:@selector(finishedOpenAllRequest:) token:nil];
//    
//    
//       //获取分享信息
//       urlString = [NSString stringWithFormat:@"%@/share.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
//       temp = [[[RCHttpRequest alloc] init] autorelease];
//       [temp request:urlString delegate:self resultSelector:@selector(finishedShareTextRequest:) token:nil];
//    
//    
//       //检查最新版本
//       urlString = [NSString stringWithFormat:@"%@/check_update.php?apiid=%@&pwd=%@&ios=1",BASE_URL,APIID,PWD];
//       temp = [[[RCHttpRequest alloc] init] autorelease];
//       [temp request:urlString delegate:self resultSelector:@selector(finishedCheckRequest:) token:nil];
//    
//       //获取说明文字
//        urlString = [NSString stringWithFormat:@"%@/intro.php?apiid=%@&pwd=%@&ios=1",BASE_URL,APIID,PWD];
//        temp = [[[RCHttpRequest alloc] init] autorelease];
//        [temp request:urlString delegate:self resultSelector:@selector(finishedIntroRequest:) token:nil];
    
    
    return YES;
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setAd:@"open" ad:result];
    }
    
}

- (void)finishedOpenAllRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* value = [result objectForKey:@"test"];
        if([value isEqualToString:@"1"])
            [RCTool setOpenAll:NO];
        else if([value isEqualToString:@"0"])
            [RCTool setOpenAll:YES];
    }
    
}

- (void)finishedAreaRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [result objectForKey:@"arealist"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            [RCTool setArea:array];
        }
        
        array = [result objectForKey:@"typelist"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            [RCTool setHouseType:array];
        }
    }
}

- (void)finishedShareTextRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        
    }
}


- (void)finishedCheckRequest:(NSString*)jsonString
{
}

- (void)finishedIntroRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setIntro:result];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
}

- (void)removeLauchAdView
{
//    if(_lauchAdView)
//    {
////        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        
//        [UIView animateWithDuration:2.0 animations:^{
//            _lauchAdView.alpha = 0.0;
//        }completion:^(BOOL finished) {
//            [_lauchAdView removeFromSuperview];
//            self.lauchAdView = nil;
//            
//            [_homeViewController clickedLocationButton:nil];
//        }];
//    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    UIApplication* app = [UIApplication sharedApplication];
	app.applicationIconBadgeNumber = 0;
	[app registerForRemoteNotificationTypes:
	 (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance]
     setActive: YES error: &activationErr];
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RCFang" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RCFang.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Push Notification

- (void)sendProviderDeviceToken:(NSData*)devToken
{
	if(nil == devToken)
		return;
    
    NSString* temp = [devToken description];
	NSString* token = [temp stringByTrimmingCharactersInSet:
					   [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSLog(@"token:%@",token);
    
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [RCTool setDeviceToken:token];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&pwd=%@&type=index&iostoken=%@",BASE_URL,APIID,PWD,token];
    
    RCHttpRequest* temp2 = [[[RCHttpRequest alloc] init] autorelease];
    [temp2 request:urlString delegate:self resultSelector:nil token:nil];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [self sendProviderDeviceToken: devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"%@",[userInfo valueForKeyPath:@"aps.alert"]);
	
	UIApplication* app = [UIApplication sharedApplication];
	if(app.applicationIconBadgeNumber)
		app.applicationIconBadgeNumber = 0;
	else
	{
		NSString* message = [userInfo valueForKeyPath:@"aps.alert"];
		if([message length])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"风行车管家"
															message: message delegate: self
												  cancelButtonTitle: @"确定"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
	}
}


@end
