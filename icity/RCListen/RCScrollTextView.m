//
//  RCScrollTextView.m
//  RCFang
//
//  Created by xuzepei on 8/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCScrollTextView.h"

#define LINE_MAX_LENGTH 23

@implementation RCScrollTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scroll_text_view_bg"]];
        
        _scrollLabel = [[BBCyclingLabel alloc] initWithFrame:CGRectMake(16, 0, 300, frame.size.height)];
        _scrollLabel.font = [UIFont systemFontOfSize:14];
        _scrollLabel.textColor = [UIColor colorWithRed:0.00 green:0.10 blue:0.20 alpha:1.00];
//        _scrollLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
        _scrollLabel.shadowOffset = CGSizeMake(0, 1);
        _scrollLabel.numberOfLines = 1;
        _scrollLabel.textAlignment = UITextAlignmentLeft;
        _scrollLabel.transitionDuration = 0.75;
        _scrollLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
        _scrollLabel.clipsToBounds = YES;
        _scrollLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview: _scrollLabel];
    
    }
    return self;
}

- (void)dealloc
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.textArray = nil;
    self.scrollLabel = nil;
    self.delegate = nil;
    self.item = nil;
    
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

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSString* text = [self.item objectForKey:@"title"];
    
    [_textArray removeAllObjects];
    _showIndex = 0;
    
    int length = [text length];
    int offset = 0;
    while (length) {
        if(length >= LINE_MAX_LENGTH)
        {
            [_textArray addObject:[text substringWithRange:NSMakeRange(offset, LINE_MAX_LENGTH)]];
            offset += LINE_MAX_LENGTH;
            length -= LINE_MAX_LENGTH;
        }
        else if(length > 0)
        {
            [_textArray addObject:[text substringWithRange:NSMakeRange(offset, length)]];
            offset += length;
            length -= length;
        }
    }

    NSString* id = [self.item objectForKey:@"id"];
    [self showText:id];
}

- (void)showText:(id)argument
{
    NSString* id = [self.item objectForKey:@"id"];
    
    NSString* oldId = (NSString*)argument;
    if(NO == [oldId isEqualToString:id])
        return;
    
    if(_showIndex >= [_textArray count])
    {
        if(_delegate && [_delegate respondsToSelector:@selector(scrollToEnd:)])
        {
            _showIndex = 0;
            [_delegate scrollToEnd:nil];
            return;
        }
    }
    
    if(_showIndex < [_textArray count])
    {
        NSString* text = [_textArray objectAtIndex:_showIndex];
        [_scrollLabel setText:text animated:YES];
        _showIndex++;
    }
    
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(handleTimer:) userInfo:id repeats:NO];
    //[self performSelector:@selector(showText:) withObject:id afterDelay:3.0];
}

- (void)handleTimer:(NSTimer*)timer
{
    [self showText:[timer userInfo]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedText:)])
    {
        [_delegate clickedText:self.item];
    }
}

@end
