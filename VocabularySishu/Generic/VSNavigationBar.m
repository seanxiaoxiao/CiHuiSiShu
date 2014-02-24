//
//  VSNavigationBar.m
//  VocabularySishu
//
//  Created by xiao xiao on 7/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSNavigationBar.h"

@implementation VSNavigationBar

@synthesize backgroundImageView = _backgroundImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateBackgroundImage
{
    UIImage *image = [VSUtils fetchImg:@"Navigation"];
    [[self backgroundImageView] setImage:image];
    [self sendSubviewToBack:_backgroundImageView];
}

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
        [_backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self insertSubview:_backgroundImageView atIndex:0];
    }
    
    return _backgroundImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
