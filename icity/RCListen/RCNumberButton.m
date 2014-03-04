//
//  RCNumberButton.m
//  RCFang
//
//  Created by xuzepei on 8/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCNumberButton.h"

@implementation RCNumberButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if(nil == _numberView)
    {
        _numberView = [[RCNumberView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0, -10, 34, 20)];
        _numberView.hidden = YES;
    }
    
    [self addSubview:_numberView];
}

- (void)dealloc
{
    self.numberView = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateNumber:(int)number
{
    if(number <= 0)
        self.numberView.hidden = YES;
    else
        self.numberView.hidden = NO;
        
    [self.numberView updateNumber:number];
}

@end
