//
//  RCUploadPhotoViewController.m
//  iCity
//
//  Created by xuzepei on 3/19/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCUploadPhotoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define BG_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:234/255.0 alpha:1.0]

#define OFFSET_HEIGHT 248.0f
#define IMAGE_WIDTH 80.0f
#define IMAGE_INTERVAL 20.0f

@interface RCUploadPhotoViewController ()

@end

@implementation RCUploadPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"上传图片";
        
        _imageArray = [[NSMutableArray alloc] init];
        _imageUrlArray = [[NSMutableArray alloc] init];
        _imageViewArray = [[NSMutableArray alloc] init];
        
        UIBarButtonItem* rightItem = [[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(clickedUploadButtonItem:)] autorelease];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.time = [[NSDate date] timeIntervalSince1970];
        
        
        if(nil == _textview)
        {
            _textview = [[RCPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT + 10, 300, 160)];
            _textview.placeholder = @"请输入140个字符以内的描述";
            _textview.delegate = self;
            _textview.returnKeyType = UIReturnKeyDone;
            _textview.layer.cornerRadius = 10.0;
            _textview.font = [UIFont systemFontOfSize:16];
        }
        
        [self.view addSubview:_textview];
    }
    return self;
}

- (void)dealloc{
    
    self.textview = nil;
    self.addButton = nil;
    
    self.imageArray = nil;
    self.imageUrlArray = nil;
    self.imageViewArray = nil;
    
    self.jqid = nil;
    
    [super dealloc];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BG_COLOR;
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
    self.addButton.frame = CGRectMake(IMAGE_INTERVAL,OFFSET_HEIGHT, IMAGE_WIDTH, IMAGE_WIDTH);
    [self.addButton addTarget:self action:@selector(clickedAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedAddButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"用户相册", nil];

    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if(CHOOSE_IMAGE_TAG == actionSheet.tag)
    {
        switch (buttonIndex) {
            case 0:
            {
                [self takePhoto];
                break;
            }
            case 1:
            {
                [self choosePhoto];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Choose Picture
- (void)takePhoto
{
	UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing = YES;
		[self presentModalViewController:imagePickerController animated:YES];
	}
	else
	{
		[RCTool showAlert:@"提示" message:@"该设备不支持拍照功能。"];
	}
}

- (void)choosePhoto
{
	UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing = YES;
		[self presentModalViewController:imagePickerController animated:YES];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (nil == image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    image = [RCTool scaleAndRotateImage:image];
    NSString* imageUrl = [RCTool saveSendImageToLocal:image];
    
    [_imageUrlArray addObject:imageUrl];
    [_imageArray addObject:image];

	
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self rearrange];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)rearrange
{
    CGFloat offset_y = OFFSET_HEIGHT;
    CGFloat offset_x = IMAGE_INTERVAL;
    
    int i = 0;
    for(UIImage* image in _imageArray)
    {
        int x = i / 3;
        int y = i % 3;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset_x + (IMAGE_INTERVAL + IMAGE_WIDTH)*y, offset_y + (IMAGE_INTERVAL + IMAGE_WIDTH)*x, IMAGE_WIDTH, IMAGE_WIDTH)];
        imageView.image = image;
        [self.view addSubview:imageView];
        
        [_imageViewArray addObject:imageView];
        
        i++;
    }
    
    if([_imageArray count] >= 6)
    {
        [self.addButton removeFromSuperview];
        return;
    }
    
    int x = i / 3;
    int y = i % 3;

    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = CGRectMake(offset_x + (IMAGE_INTERVAL + IMAGE_WIDTH)*y, offset_y + (IMAGE_INTERVAL + IMAGE_WIDTH)*x, IMAGE_WIDTH, IMAGE_WIDTH);
        self.addButton.frame = rect;

    }];
}

- (void)clickedUploadButtonItem:(id)sender
{
    NSLog(@"clickedUploadButtonItem");
    
    if(0 == [self.jqid length])
        return;
    
    if(0 == [self.textview.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入图片描述！"];
        return;
    }
    
    if([self.textview.text length] > 140)
    {
        [RCTool showAlert:@"提示" message:@"描述文字不能多余140个字符！"];
        return;
    }
    
    if([_imageUrlArray count])
    {
        NSString* imagePath = [_imageUrlArray objectAtIndex:0];
        NSData* imageData = [RCTool getSendImageDataFromLocal:imagePath];
        if(nil == imageData)
            return;
        
        NSString* urlString = [NSString stringWithFormat:@"%@/index.php?c=main&a=uploadpic",BASE_URL];
        NSURL* url = [NSURL URLWithString:urlString];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request addPostValue:[RCTool getDeviceID] forKey:@"token"];
        [request addPostValue:[NSNumber numberWithDouble:self.time] forKey:@"time"];
        [request addPostValue:self.textview.text forKey:@"desc"];
        [request addPostValue:self.textview.text forKey:@"jqid"];
        
        [request setData:imageData withFileName:[RCTool md5:imagePath] andContentType:@"image/png" forKey:@"userpic"];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(uploadRequestFinished:)];
        [request setDidFailSelector:@selector(uploadRequestFailed:)];
        
        [request startAsynchronous];
    }
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    if([responseString length])
    NSLog("Upload response %@", responseString);
    
    if([_imageUrlArray count])
    {
        [_imageUrlArray removeObjectAtIndex:0];
        
        [self clickedUploadButtonItem:nil];
    }
    else
    {
        [self clear];
    }
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
    
    [self clear];
}

- (void)clear
{
    [self.imageArray removeAllObjects];
    [self.imageUrlArray removeAllObjects];
    
    for(UIView* imageView in self.imageViewArray)
    {
        [imageView removeFromSuperview];
    }
    
    [self.imageViewArray removeAllObjects];
    
    [self rearrange];
}

@end
