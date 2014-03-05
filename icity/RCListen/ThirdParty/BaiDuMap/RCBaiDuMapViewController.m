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

    }
    return self;
}

- (void)dealloc
{
    self.mapView = nil;
    self.address = nil;
    self.myTitle = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(nil == _mapView)
    {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        self.view = self.mapView;
    }
    
    NSArray* points = [self.item objectForKey:@"points"];
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

- (void)updateContent:(NSDictionary*)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    NSArray* points = [item objectForKey:@"points"];
    if(0 == [points count])
        return;
    
    NSDictionary* point = [points objectAtIndex:0];
    self.address = [point objectForKey:@"jd_gps"];
    
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
                    
                    [_mapView setZoomEnabled:YES];
                    [_mapView setZoomLevel:11];
                    
                    [_mapView setRegion:region animated:YES];
                }
            }
        }
    }
    
    for(NSDictionary* point in points)
    {
        NSString* address = [point objectForKey:@"jd_gps"];
        NSString* title = [point objectForKey:@"jd_name"];
        [self addAnnotation:address title:title];
    }
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
