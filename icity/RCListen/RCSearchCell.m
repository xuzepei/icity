//
//  RCSearchCell.m
//  RCFang
//
//  Created by xuzepei on 3/13/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSearchCell.h"

@implementation RCSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 210, 20)];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textColor = [UIColor grayColor];
        _valueLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview: _valueLabel];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContent:(NSDictionary*)item
{
    NSString* name = [item objectForKey:@"name"];
    self.textLabel.text = name;
    
    int selected_value_index = [[item objectForKey:@"selected_value_index"] intValue];
    
    NSArray* values = [item objectForKey:@"values"];
    if(selected_value_index < [values count])
    {
        NSDictionary* value = [values objectAtIndex:selected_value_index];
        
        if(value && [value isKindOfClass:[NSDictionary class]])
            self.valueLabel.text = [value objectForKey:@"name"];
        else if([value isKindOfClass:[NSString class]])
            self.valueLabel.text = value;
    }
    else
        self.valueLabel.text = @"";
}

@end
