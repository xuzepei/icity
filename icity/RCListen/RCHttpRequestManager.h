//
//  RCHttpRequestManager.h
//  RCFang
//
//  Created by xuzepei on 8/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHttpRequestManager : NSObject

@property(nonatomic,retain)NSMutableArray* requestingUrlArray;

+ (RCHttpRequestManager*)sharedInstance;

- (void)requestUserInfo;

@end
