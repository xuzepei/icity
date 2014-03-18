//
//  RCBaiDuMapViewController.m
//  RCFang
//
//  Created by xuzepei on 10/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCBaiDuMapViewController.h"
#import "RCPointOverlayView.h"

@interface RCBaiDuMapViewController ()

@end

@implementation RCBaiDuMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        if(nil == _mapView)
        {
            _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
            self.view = self.mapView;
            
            [_mapView setShowsUserLocation:YES]; 
        }
    }
    return self;
}

- (void)dealloc
{
    self.mapView = nil;
    self.address = nil;
    self.myTitle = nil;
    self.search = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(nil == self.item)
        return;
    
    NSArray* points = [self.item objectForKey:@"points"];
    if(0 == [points count])
        return;
    
    if(1 == [points count])
    {
        NSDictionary* point = [points lastObject];
        NSString* address = [point objectForKey:@"jd_gps"];
        if(0 == [address length])
            address = [point objectForKey:@"gps"];
        
        NSArray* array = [address componentsSeparatedByString:@","];
        if(2 == [array count])
        {
            CLLocationCoordinate2D endLocation;
            endLocation.latitude = [[array objectAtIndex:1] floatValue];
            endLocation.longitude = [[array objectAtIndex:0] floatValue];
            
            CLLocationCoordinate2D startLocation = _mapView.userLocation.location.coordinate;
            
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.pt = startLocation;
            start.name = nil;
            
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.pt = endLocation;
            end.name = nil;
            
            if(nil == _search)
            {
                _search = [[BMKSearch alloc]init];
                _search.delegate = self;
            }
            
            BOOL flag = [_search drivingSearch:nil startNode:start endCity:nil endNode:end];
            if (!flag) {
                NSLog(@"search failed");
            }
            [start release];
            [end release];
        }
    }

}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self addAnnotation:self.address title:nil];
}

- (void)updateContent:(NSDictionary *)item zoom:(int)zoom
{
    if(nil == item)
        return;
    
    self.item = item;
    
    NSArray* points = [item objectForKey:@"points"];
    if(0 == [points count])
        return;
    
    NSDictionary* point = [points objectAtIndex:0];
    self.address = [point objectForKey:@"jd_gps"];
    
    if(0 == [self.address length])
        self.address = [point objectForKey:@"gps"];
    
    
    if([self.address length])
    {
        if(_mapView)
        {
            NSArray* array = [self.address componentsSeparatedByString:@","];
            if(2 == [array count])
            {
                CLLocationCoordinate2D coor;
                coor.latitude = [[array objectAtIndex:1] floatValue];
                coor.longitude = [[array objectAtIndex:0] floatValue];
                
                if(CLLocationCoordinate2DIsValid(coor))
                {
                    BMKCoordinateSpan span;
                    span.latitudeDelta = 1.0;
                    span.longitudeDelta = 1.0;
                    
                    BMKCoordinateRegion region;
                    region.center = coor;
                    region.span = span;
                    
                    [_mapView setRegion:region animated:NO];
                    
                    [_mapView setZoomEnabled:YES];
                    [_mapView setZoomLevel:zoom];
                }
            }
        }
    }
    
    for(NSDictionary* point in points)
    {
        NSString* address = [point objectForKey:@"jd_gps"];
        if(0 == [address length])
            address = [point objectForKey:@"gps"];
        
        NSString* title = [point objectForKey:@"jd_name"];
        if(0 == [title length])
            title = [point objectForKey:@"name"];
        
        [self addAnnotation:address title:title];
    }
    
    if(1 == [points count])
    {
        NSDictionary* point = [points lastObject];
        NSString* address = [point objectForKey:@"jd_gps"];
        if(0 == [address length])
            address = [point objectForKey:@"gps"];
        
        NSArray* array = [address componentsSeparatedByString:@","];
        if(2 == [array count])
        {
            CLLocationCoordinate2D endLocation;
            endLocation.latitude = [[array objectAtIndex:1] floatValue];
            endLocation.longitude = [[array objectAtIndex:0] floatValue];
            
            CLLocationCoordinate2D startLocation = _mapView.userLocation.location.coordinate;
            
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.pt = startLocation;
            start.name = nil;
            
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.pt = endLocation;
            end.name = nil;
            
            if(nil == _search)
            {
                _search = [[BMKSearch alloc]init];
                _search.delegate = self;
            }
            
            BOOL flag = [_search drivingSearch:nil startNode:start endCity:nil endNode:end];
            if (!flag) {
                NSLog(@"search failed");
            }
            [start release];
            [end release];
        }
    }

}

- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSLog(@"onGetTransitRouteResult:error%d",error);
}

- (void)updateContent:(NSDictionary*)item
{
    [self updateContent:item zoom:11];
}

#pragma mark - Annotation

- (void)addAnnotation:(NSString*)address title:(NSString*)title
{
    NSArray* array = [address componentsSeparatedByString:@","];
    if(2 == [array count])
    {
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[array objectAtIndex:1] floatValue];
        coor.longitude = [[array objectAtIndex:0] floatValue];
        annotation.coordinate = coor;
        annotation.title = title;
        [self.mapView addAnnotation:annotation];
        [annotation release];
    }
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
        //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return [newAnnotationView autorelease];
    }
    
    return nil;
}

#pragma mark - addOverlay

- (void)addOverlay:(NSString*)address
{
    NSArray* array = [self.address componentsSeparatedByString:@","];
    if(2 == [array count])
    {
        CLLocationCoordinate2D coor;
        coor.latitude = [[array objectAtIndex:1] floatValue];
        coor.longitude = [[array objectAtIndex:0] floatValue];
        
        BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:coor radius:1000];
        [self.mapView addOverlay:circle];
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView *view = [[BMKCircleView alloc] initWithOverlay:overlay];
        //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //view.animatesDrop = YES;// 设置该标注点动画显示
        return [view autorelease];
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
