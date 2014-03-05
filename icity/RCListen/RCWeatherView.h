//
//  RCWeatherView.h
//  iCity
//
//  Created by xuzepei on 3/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCWeatherView : UIView

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)NSString* imageUrl0;
@property(nonatomic,retain)UIImage* image0;
@property(nonatomic,retain)NSString* imageUrl1;
@property(nonatomic,retain)UIImage* image1;
@property(nonatomic,retain)NSString* imageUrl2;
@property(nonatomic,retain)UIImage* image2;

- (void)updateContent:(NSDictionary*)item;

@end
