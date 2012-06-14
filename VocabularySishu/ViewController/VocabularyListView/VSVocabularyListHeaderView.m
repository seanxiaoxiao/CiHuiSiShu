//
//  VSVocabularyListHeaderView.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyListHeaderView.h"

@implementation VSVocabularyListHeaderView

@synthesize finishRateBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishRateBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        [self addSubview:self.finishRateBar];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    self.finishRateBar.progress = progress;
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
