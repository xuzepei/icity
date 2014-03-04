//
//  RCIndexAdCell1.m
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCIndexAdCell1.h"

@implementation RCIndexAdCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.myLabel = nil;
    self.im0 = nil;
    self.im1 = nil;
    self.im2 = nil;
    self.im3 = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
