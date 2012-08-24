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
@synthesize wordRemainLabel;
@synthesize remainBackground;

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

        self.wordRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 22, 40, 20)];
        self.wordRemainLabel.backgroundColor = [UIColor clearColor];
        self.wordRemainLabel.font = [UIFont fontWithName:@"Dakota" size:20];
        self.wordRemainLabel.textAlignment = UITextAlignmentCenter;
        self.wordRemainLabel.text = @"-";
        self.wordRemainLabel.textColor = [UIColor colorWithHue:240.0/360.0 saturation:0.7 brightness:0.3 alpha:1];
        
        UIImage *markImage = [VSUtils fetchImg:@"Mark"];
        self.remainBackground = [[UIImageView alloc] initWithImage:markImage];
        self.remainBackground.frame = CGRectMake(258, 9, markImage.size.width, markImage.size.height);

        self.penBG.frame = CGRectMake(-40, 20, penBGImage.size.width, penBGImage.size.height);
        self.penFG.frame = CGRectMake(-40, 20, penFGImage.size.width, penFGImage.size.height);
        self.inkHeader.frame = CGRectMake(0, 20, inkHeadImage.size.width, inkHeadImage.size.height);
        self.inkNeck.frame = CGRectMake(inkHeadImage.size.width, 20, inkNeckImage.size.width, inkNeckImage.size.height);
        self.inkBody.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width, 20, inkBodyImage.size.width, inkBodyImage.size.height);
        self.inkFooter.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + inkBodyImage.size.width, 20, 160, inkBodyImage.size.height);
        [self addSubview:self.penBG];
        [self addSubview:self.penFG];
        [self addSubview:self.inkHeader];
        [self addSubview:self.inkNeck];
        [self addSubview:self.inkBody];
        [self addSubview:self.inkFooter];
        [self addSubview:self.wordRemainLabel];
        [self addSubview:self.remainBackground];
        
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
    double margin = progress * 160;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationCurveLinear 
        animations:^{
            self.inkNeck.frame = CGRectMake(inkHeadImage.size.width, 20, inkNeckImage.size.width + margin, inkNeckImage.size.height);
            self.inkBody.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + margin, 20, inkBodyImage.size.width, inkBodyImage.size.height);
            self.inkFooter.frame = CGRectMake(inkNeckImage.size.width + inkHeadImage.size.width + margin + inkBodyImage.size.width, 20, 160 - margin, inkBodyImage.size.height);
        }
        completion:^(BOOL finished) {
    
        }];
}

- (void) setWordRemains:(int)wordRemain
{
    self.wordRemain = wordRemain;
    self.wordRemainLabel.text = [NSString stringWithFormat:@"%d", self.wordRemain];
}

- (void) decrWordRemain
{
    self.wordRemain--;
    self.wordRemainLabel.text = [NSString stringWithFormat:@"%d", self.wordRemain];
}

@end
