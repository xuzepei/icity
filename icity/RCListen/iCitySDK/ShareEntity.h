//
//  ShareEntity.h
//  iCityPlus
//
//  Created by higgses on 14-5-14.
//  Copyright (c) 2014年 Chanly Inc. All rights reserved.
//

#import "BEntity.h"

@interface ShareEntity : BEntity

/**
 *  分享标题
 */
@property(nonatomic, retain)NSString* shareTitle;


/**
 *  分享内容
 */
@property(nonatomic, retain)NSString* shareContent;

/**
 *  分享图片
 */
@property(nonatomic, retain)NSString* shareImgURL;

/**
 *  分享链接
 */
@property(nonatomic, retain)NSString* shareUrl;


@end
