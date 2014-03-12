//
//  RCJianJieViewController.m
//  iCity
//
//  Created by xuzepei on 3/11/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJianJieViewController.h"
#import "RCImageLoader.h"

@interface RCJianJieViewController ()

@end

@implementation RCJianJieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.imageView = nil;
    self.textView = nil;
    self.image = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = [self.item objectForKey:@"jd_desc"];
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
    UIImage* image = [RCTool getImageFromLocal:imageUrl];
    if(image)
        self.imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.title = [self.item objectForKey:@"jd_name"];
    
    self.textView.text = [self.item objectForKey:@"jd_desc"];
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
    UIImage* image = [RCTool getImageFromLocal:imageUrl];
    if(image)
        self.imageView.image = image;
    else
    {
        [[RCImageLoader sharedInstance] saveImage:imageUrl
                                         delegate:self
                                            token:nil];
    }
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
    NSString* imageUrl = [self.item objectForKey:@"jd_picurl"];
	if([urlString isEqualToString:imageUrl])
	{
		self.imageView.image = [RCTool getImageFromLocal:imageUrl];
	}
}

@end
