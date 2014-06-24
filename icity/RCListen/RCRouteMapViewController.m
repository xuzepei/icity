//
//  RCRouteMapViewController.h
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCRouteMapViewController.h"

@interface RCRouteMapViewController ()

@end

@implementation RCRouteMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _pointArray = [[NSMutableArray alloc] init];
        
        [self initButton];
    }
    return self;
}

- (void)dealloc
{
    self.pointArray = nil;
    self.stepper = nil;
    self.gpsButton = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.gpsButton)
        [[RCTool frontWindow] addSubview:self.gpsButton];
    
    if(self.stepper)
        [[RCTool frontWindow] addSubview:self.stepper];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.gpsButton)
        [self.gpsButton removeFromSuperview];
    
    if(self.stepper)
        [self.stepper removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)initButton
{
    if(nil == _stepper)
    {
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(20,[RCTool getScreenSize].height - 60, 100, 40)];
        _stepper.value = 17;
        _stepper.maximumValue = 19;
        _stepper.minimumValue = 3;
        _stepper.stepValue = 1;
        
        if([RCTool systemVersion] < 7.0)
            _stepper.tintColor = [UIColor clearColor];
        else
            _stepper.tintColor = [UIColor blackColor];
        
        [_stepper setDecrementImage:[UIImage imageNamed:@"zoom_out"] forState:UIControlStateNormal];
        [_stepper setIncrementImage:[UIImage imageNamed:@"zoom_in"] forState:UIControlStateNormal];
        [_stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    [[RCTool frontWindow] addSubview:self.stepper];
    
    if(nil == _gpsButton)
    {
        self.gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_button"] forState:UIControlStateNormal];
        self.gpsButton.frame = CGRectMake(0, 0, 40, 40);
        self.gpsButton.center = CGPointMake([RCTool getScreenSize].width - 46, [RCTool getScreenSize].height - 46);
        self.gpsButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.gpsButton.layer.borderWidth = 1;
        self.gpsButton.layer.cornerRadius = 7.0f;
        
        [self.gpsButton addTarget:self action:@selector(clickedGPSButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[RCTool frontWindow] addSubview:self.gpsButton];
}

- (void)stepperValueChanged:(id)sender
{
    UIStepper* stepper = (UIStepper*)sender;
    if(stepper)
    {
        NSLog(@"stepper.value:%f",stepper.value);
        
        [self.mapView setZoomLevel:(float)stepper.value];
    }
    
}

- (void)clickedGPSButton:(id)sender
{
    NSLog(@"clickedGPSButton");
    
    [self route:nil];
    
    BMKCoordinateRegion region;
    region.center.latitude  = super.mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = super.mapView.userLocation.location.coordinate.longitude;
    [super.mapView setRegion:region animated:YES];
}

- (void)updateContent:(NSArray *)itemArray title:(NSString *)title
{
    if(0 == [itemArray count])
        return;
    
    self.title = title;
    
    NSDictionary* token = [NSDictionary dictionaryWithObject:itemArray forKey:@"points"];
    [super updateContent:token zoom:17];
    
    [self performSelector:@selector(route:) withObject:nil afterDelay:3.0];
}

- (void)route:(id)agrument
{
    [super route];
}

@end
