//
//  RCHttpRequestManager.m
//  RCFang
//
//  Created by xuzepei on 8/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCHttpRequestManager.h"
#import "RCHttpRequest.h"
#import "RCTool.h"

@implementation RCHttpRequestManager

+ (RCHttpRequestManager*)sharedInstance
{
    static RCHttpRequestManager* sharedInstance = nil;
    
    if(nil == sharedInstance)
    {
        @synchronized([RCHttpRequestManager class])
        {
            if(nil == sharedInstance)
            {
                sharedInstance = [[RCHttpRequestManager alloc] init];
            }
        }
    }
    
    return sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        _requestingUrlArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.requestingUrlArray = nil;
    [super dealloc];
}

- (BOOL)isRequesting:(NSString*)urlString
{
    if(0 == [urlString length])
        return NO;
    
    if([self.requestingUrlArray containsObject:urlString])
        return YES;
    
    return NO;
}

- (void)addToRequestingArray:(NSString*)urlString
{
    if(0 == [urlString length])
        return;
    
    [self.requestingUrlArray addObject:urlString];
}

- (void)removeFromRequestingArray:(NSString*)urlString
{
    if(0 == [urlString length])
        return;
    
    [self.requestingUrlArray removeObject:urlString];
}

- (void)requestUserInfo
{
    NSString* username = [RCTool getUsername];
    if( 0 == [username length])
        return;
    
    NSString* token = [NSString stringWithFormat:@"username=%@",username];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_center.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[[RCHttpRequest alloc] init] autorelease];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedUserInfoRequest:) token:token];
    if(b)
    {
    }
    
}

- (void)finishedUserInfoRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            [RCTool setUserInfo:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USERINFO_NOTIFICATION object:nil];
            return;
        }
        else
        {
            NSLog(@"finishedUserInfoRequest,error:%@",error);
        }
        
        return;
    }
    
    NSLog(@"FailedUserInfoRequest");
    
}


@end
