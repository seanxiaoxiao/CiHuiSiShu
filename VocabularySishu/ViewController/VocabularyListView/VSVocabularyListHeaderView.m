//
//  VSVocabularyListHeaderView.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyListHeaderView.h"

@implementation VSVocabularyListHeaderView

@synthesize penBG;
@synthesize penFG;
@synthesize inkHeader;
@synthesize inkNeck;
@synthesize inkBody;
@synthesize inkFooter;

@synthesize inkBodyImage;
@synthesize inkFooterImage;
@synthesize inkHeadImage;
@synthesize inkNeckImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *penBGImage = [VSUtils fetchImg:@"PenBG"];
        UIImage *penFGImage = [VSUtils fetchImg:@"PenFG"];
        self.inkHeadImage = [VSUtils fetchImg:@"InkHeader"];
        self.inkNeckImage = [VSUtils fetchImg:@"InkNeck"];
        self.inkBodyImage = [VSUtils fetchImg:@"InkBody"];
        self.inkFooterImage = [VSUtils fetchImg:@"InkFooter"];

        self.penBG = [[UIImageView alloc] initWithImage:penBGImage];
        self.penFG = [[UIImageView alloc] initWithImage:penFGImage];
        self.inkHeader = [[UIImageView alloc] initWithImage:self.inkHeadImage];
        self.inkNeck = [[UIImageView alloc] initWithImage:self.inkNeckImage];
        self.inkBody = [[UIImageView alloc] initWithImage:self.inkBodyImage];
        self.inkFooter = [[UIImageView alloc] initWithImage:self.inkFooterImage];

        self.penBG.frame = CGRectMake(0, 20, penBGImage.size.width, penBGImage.size.height);
        self.penFG.frame = CGRectMake(0, 20, penFGImage.size.width, penFGImage.size.height);
        self.inkHeader.frame = CGRectMake(0, 20, inkHeadImage.size.width, inkHeadImage.size.height);
        self.inkNeck.frame = CGRectMake(inkHeadImage.size.width, 20, inkNeckImage.size.width, inkNeckImage.size.height);
        self.inkBody.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width, 20, inkBodyImage.size.width, inkBodyImage.size.height);
        self.inkFooter.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + inkBodyImage.size.width, 20, 200, inkBodyImage.size.height);
        [self addSubview:self.penBG];
        [self addSubview:self.penFG];
        [self addSubview:self.inkHeader];
        [self addSubview:self.inkNeck];
        [self addSubview:self.inkBody];
        [self addSubview:self.inkFooter];
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

- (void) updateProgress:(double)progress
{
    double margin = progress * 200;
    self.inkNeck.frame = CGRectMake(inkHeadImage.size.width, 20, inkNeckImage.size.width + margin, inkNeckImage.size.height);
    self.inkBody.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + margin, 20, inkBodyImage.size.width, inkBodyImage.size.height);
    self.inkFooter.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + margin + inkBodyImage.size.width, 20, 200 - margin, inkBodyImage.size.height);
}

@end
