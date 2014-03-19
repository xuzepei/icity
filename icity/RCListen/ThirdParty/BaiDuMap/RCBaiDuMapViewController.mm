//
//  RCBaiDuMapViewController.m
//  RCFang
//
//  Created by xuzepei on 10/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCBaiDuMapViewController.h"
#import "RCPointOverlayView.h"
#import "RouteAnnotation.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

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
            _mapView.delegate = self;
            self.view = self.mapView;
            
            [_mapView setShowsUserLocation:YES];
            
            if(nil == _search)
            {
                _search = [[BMKSearch alloc]init];
                _search.delegate = self;
            }
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
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    _search.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    _search.delegate = nil;  
}

- (void)viewDidAppear:(BOOL)animated
{

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
    
}



- (void)updateContent:(NSDictionary*)item
{
    [self updateContent:item zoom:13];
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
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:self.mapView viewForAnnotation:(RouteAnnotation*)annotation];
	}
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
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
    else if([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    //NSLog(@"mapViewWillStartLocatingUser");
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation");
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    //NSLog(@"mapViewDidStopLocatingUser");
}

#pragma mark - Route

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

- (void)route
{
    if(nil == self.item)
        return;
    
    NSArray* points = [self.item objectForKey:@"points"];
    if(0 == [points count])
        return;
    
    NSDictionary* point = [points objectAtIndex:0];
    self.address = [point objectForKey:@"jd_gps"];
    
    if(0 == [self.address length])
        self.address = [point objectForKey:@"gps"];
    
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

            BOOL flag = [_search drivingSearch:nil startNode:start endCity:nil endNode:end];
            if (!flag) {
                NSLog(@"search failed");
                
//                static int i = 0;
//                if(i < 3)
//                {
//                    [self route];
//                    i++;
//                }
            }
            [start release];
            [end release];
        }
    }
    
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            [item release];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                    [item release];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            [item release];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                    [item release];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}

@end
