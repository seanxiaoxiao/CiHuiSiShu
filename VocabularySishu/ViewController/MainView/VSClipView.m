//
//  VSClipView.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/15/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSClipView.h"

@implementation VSClipView

@synthesize scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return scrollView;
    }
    return nil;
}
@end
