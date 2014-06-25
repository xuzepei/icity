//
//  BEntity.h
//  iCity2
//
//  Created by higgses on 14-4-16.
//  Copyright (c) 2014年 Chanly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BEntity : NSObject
<NSCoding>
{
	NSDictionary *iniProperty;
}

/**
 *  属性配置  {@"本地属性":@"服务器key值"}
 */
@property(nonatomic, retain)NSDictionary *iniProperty;

- (void)configProperty;

- (BEntity *)initWithData:(NSDictionary *)dt;

@end
