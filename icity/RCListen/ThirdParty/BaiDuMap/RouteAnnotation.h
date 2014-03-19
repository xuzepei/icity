//
//  RouteAnnotation.h
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface RouteAnnotation : BMKPointAnnotation

@property (assign) int type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
@property (assign) int degree;

@end
