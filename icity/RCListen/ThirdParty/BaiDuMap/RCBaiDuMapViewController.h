//
//  RCBaiDuMapViewController.h
//  RCFang
//
//  Created by xuzepei on 10/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RCBaiDuMapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate>


@property(nonatomic,retain)BMKMapView* mapView;
@property(nonatomic,retain)NSString* address;
@property(nonatomic,retain)NSString* myTitle;
@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)BMKSearch* search;

- (void)updateContent:(NSDictionary*)item zoom:(int)zoom;
- (void)updateContent:(NSDictionary*)item;
- (void)addAnnotation:(NSString*)address;
- (void)addOverlay:(NSString*)address;

@end
