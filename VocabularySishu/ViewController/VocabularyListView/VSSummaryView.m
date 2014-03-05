//
//  VSSummaryView.m
//  VocabularySishu
//
//  Created by xiao xiao on 7/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSSummaryView.h"

@implementation VSSummaryView

@synthesize vocabulary;
@synthesize summaryLabel;
@synthesize backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellSummary"]];
        [self addSubview:backgroundImage];
        [self sendSubviewToBack:backgroundImage];
        
        CGRect summaryFrame = CGRectMake(30, 3, 260, self.frame.size.height);
        summaryLabel = [[UILabel alloc] initWithFrame:summaryFrame];
        
        [summaryLabel setTextAlignment:NSTextAlignmentCenter];
        summaryLabel.text = vocabulary.summary;
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.textColor = [UIColor blackColor];
        summaryLabel.alpha = 0.7f;
        summaryLabel.font = [UIFont fontWithName:@"Verdana" size:16];
        summaryLabel.numberOfLines = 0;
        summaryLabel.shadowOffset = CGSizeMake(0, 1);
        summaryLabel.shadowColor = [UIColor whiteColor];
        [self addSubview:summaryLabel];
    }
    return self;
}


@end
