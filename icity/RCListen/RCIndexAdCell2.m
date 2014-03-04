//
//  RCIndexAdCell2.m
//  RCFang
//
//  Created by xuzepei on 10/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCIndexAdCell2.h"

@implementation RCIndexAdCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel* label0 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 6, 34, 20)] autorelease];
        label0.backgroundColor = [UIColor clearColor];
        label0.font = [UIFont systemFontOfSize:14];
        label0.text = @"网址:";
        [self.contentView addSubview:label0];
        
        self.linkButton = [RCLinkButton buttonWithType:UIButtonTypeCustom];
        self.linkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.linkButton.frame = CGRectMake(50, 6, 250, 20);
        self.linkButton.titleLabel.textColor = [UIColor blueColor];
        self.linkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.linkButton addTarget:self action:@selector(clickedLinkButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.linkButton];
        
        
        self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(2, 30, 310, 40)] autorelease];
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.editable = NO;
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)dealloc
{
    self.linkButton = nil;
    self.delegate = nil;
    self.textView = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContent:(NSString*)content height:(CGFloat)height delegate:(id)delegate
{
    self.delegate = delegate;
    
    CGRect rect = self.textView.frame;
    rect.size.height = height - 30.0f;
    self.textView.frame = rect;
    self.textView.text = content;
}

- (void)clickedLinkButton:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedLinkButton:)])
    {
        [self.delegate clickedLinkButton:nil];
    }
}

@end
