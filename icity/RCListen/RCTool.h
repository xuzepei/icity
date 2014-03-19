//
//  RCTool.h
//  rsscoffee
//
//  Created by beer on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTool : NSObject {

}

+ (NSString*)getUserDocumentDirectoryPath;
+ (NSString *)md5:(NSString *)str;
+ (UIWindow*)frontWindow;
+ (UITabBarController*)getTabBarController;

+ (BOOL)saveImage:(NSData*)data path:(NSString*)path;
+ (NSString*)getImageLocalPath:(NSString *)path;
+ (UIImage*)getImageFromLocal:(NSString*)path;
+ (BOOL)isExistingFile:(NSString*)path;
+ (void)removeFile:(NSString*)filePath;

+ (void)setReachabilityType:(int)type;
+ (int)getReachabilityType;
+ (BOOL)isReachableViaWiFi;
+ (BOOL)isReachableViaInternet;

+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator;
+ (NSManagedObjectContext*)getManagedObjectContext;
+ (NSManagedObjectID*)getExistingEntityObjectIDForName:(NSString*)entityName
											 predicate:(NSPredicate*)predicate
									   sortDescriptors:(NSArray*)sortDescriptors
											   context:(NSManagedObjectContext*)context;

+ (NSArray*)getExistingEntityObjectsForName:(NSString*)entityName
								  predicate:(NSPredicate*)predicate
							sortDescriptors:(NSArray*)sortDescriptors;

+ (id)insertEntityObjectForName:(NSString*)entityName 
		   managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (id)insertEntityObjectForID:(NSManagedObjectID*)objectID 
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (void)saveCoreData;

+ (BOOL)isBigFont;
+ (BOOL)isAutoScroll;
+ (BOOL)isManualRefresh;
+ (BOOL)isWifiOnly;

+ (BOOL)isImageUrl:(NSString*)urlString;

+ (UIView*)getAdView;

+ (void)autoDeleteItems;

+ (void)showAlert:(NSString*)aTitle message:(NSString*)message;
+ (void)hidenWebViewShadow:(UIWebView*)webView;

+ (void)deleteOldData;

#pragma mark - 兼容iOS6和iPhone5
+ (CGSize)getScreenSize;
+ (CGRect)getScreenRect;
+ (BOOL)isIphone5;
+ (BOOL)isIpad;


#pragma mark - 搜索条件缓存

+ (BOOL)setSearchCondition:(NSArray*)conditionArray type:(int)type;
+ (NSArray*)getSearchConditionByType:(int)type;

+ (void)showIndicator:(NSString*)text;
+ (void)hideIndicator;

#pragma mark - 数据解析
//解析谷歌地图地址
+ (NSDictionary*)parseAddress:(NSString*)jsonString;
+ (NSDictionary*)parseToDictionary:(NSString*)jsonString;

+ (void)playSound:(NSString*)filename;


+ (void)setAd:(NSString*)type ad:(NSDictionary*)ad;
+ (NSDictionary*)getAdByType:(NSString*)type;

+ (void)setArea:(id)area;
+ (NSArray*)getArea;

+ (void)setHouseType:(id)type;
+ (NSArray*)getHouseType;

+ (void)setUsername:(NSString*)username;
+ (NSString*)getUsername;

+ (void)setNickname:(NSString*)nickname;
+ (NSString*)getNickname;

+ (void)setPassword:(NSString*)password;
+ (NSString*)getPassword;

+ (void)setUserInfo:(NSDictionary*)userInfo;
+ (NSDictionary*)getUserInfo;
+ (NSString*)getUserInfoBy:(NSString*)key;

+ (NSString *)getIpAddress;
+ (NSString*)base64forData:(NSData*)theData;

+ (void)setShareText:(NSString*)text;
+ (NSString*)getShareText;

+ (void)setDeviceToken:(NSString*)token;
+ (NSString*)getDeviceToken;

+ (BOOL)isLogin;

+ (NSString*)switchMapAddress:(NSString*)address;

+ (void)setIntro:(NSDictionary*)intro;
+ (NSDictionary*)getIntro;

+ (BOOL)openAll;

+ (BOOL)hasNoError:(NSDictionary*)dict;

//获取设备ID
+ (NSString*)getDeviceID;


#pragma mark - Photo
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (NSString*)saveSendImageToLocal:(UIImage *)image;
+ (NSData*)getSendImageDataFromLocal:(NSString*)imagePath;
+ (UIImage*)getSendImageFromLocal:(NSString*)imagePath;

@end
