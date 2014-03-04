//
//  RCPublicCellContentView.h
//  RCTemplate
//
//  Created by xuzepei on 11/25/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCPublicCellContentView : UIView

@property(nonatomic, retain)NSDictionary* item;
@property(nonatomic, retain)NSString* imageUrl;
@property(nonatomic, retain)UIImage* image;
@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)BOOL selected;
@property(nonatomic, retain)NSDictionary* token;

- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token;

@end
