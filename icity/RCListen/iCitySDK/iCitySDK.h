//
//  iCitySDK.h
//  iCitySDK
//
//  Created by higgses on 14-6-4.
//  Copyright (c) 2014年 Chanly Inc. All rights reserved.
//  version 2.0.2

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShareEntity;

@protocol iCitySDKDelegate <NSObject>

@optional
/**
 *  定位成功后调用
 *
 *  @param location 定位坐标信息
 */
- (void)loctionFinished:(CLLocation *)location;

/**
 *  定位出错调用
 *
 *  @param error
 */
- (void)locationFalse:(NSError *)error;


/**
 *  登录成功
 *
 *  @param data 服务器返回数据
 */
- (void)loginSuc:(NSDictionary *)data;

/**
 *  登录失败
 *
 *  @param error 错误消息
 */
- (void)loginFalse:(NSDictionary *)error;

@end

@interface iCitySDK : NSObject
@property(nonatomic, retain)id<iCitySDKDelegate> delegate;

+ (iCitySDK *)shareCitySDK;

/**
 *  分享
 *
 *  @param view 当前viewcontroller.view
 *  @param item 分享数据实体
 *  @param sel  分享完成后回调SEL  返回状态status 1成功 0失败
 */
- (void)showShareInView:(UIView *)view WithEntity:(ShareEntity *)item WithFinishSEL:(SEL)sel;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  用户登录接口
 */
- (void)doLogin;
@end
