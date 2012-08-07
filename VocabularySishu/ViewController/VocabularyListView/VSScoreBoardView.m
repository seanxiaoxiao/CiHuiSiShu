//
//  VSScoreBoardView.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSScoreBoardView.h"

@implementation VSScoreBoardView

@synthesize scoreBoardBackground;
@synthesize retryButton;
@synthesize nextButton;
@synthesize finishLabel;
@synthesize notWellLabel;
@synthesize finishRateLabel;
@synthesize notWellRateLabel;
@synthesize _list;
@synthesize finishProgress;
@synthesize notRememberWell;
@synthesize finishProgressStep;
@synthesize notRememberWellStep;
@synthesize numberFormatter;
@synthesize finishProgressTimer;
@synthesize notRememberWellTimer;
@synthesize finishProgressInList;
@synthesize notRememberWellInList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.scoreBoardBackground = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ScoreBoardPopup"]];
        [self addSubview:scoreBoardBackground];
        [self sendSubviewToBack:scoreBoardBackground];
        
        UIImage *normalButtonImage = [VSUtils fetchImg:@"ButtonBT"];
        UIImage *highlightButtonImage = [VSUtils fetchImg:@"ButtonBTHighLighted"];
        
        self.retryButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 165, normalButtonImage.size.width, normalButtonImage.size.height)];
        [self.retryButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
        [self.retryButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
        [self.retryButton setTitle:@"重新背诵" forState:UIControlStateNormal];
        [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
        self.retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.retryButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.retryButton.titleLabel.shadowColor = [UIColor blackColor];
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 165, normalButtonImage.size.width, normalButtonImage.size.height)];
        [self.nextButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
        [self.nextButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
        [self.nextButton setTitle:@"下个列表" forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.nextButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.nextButton.titleLabel.shadowColor = [UIColor blackColor];
        
        self.finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, 70, 30)];
        self.finishLabel.textAlignment = UITextAlignmentLeft;
        self.finishLabel.backgroundColor = [UIColor clearColor];
        self.finishLabel.text = @"完成度";
        self.finishLabel.font = [UIFont boldSystemFontOfSize:18];
        self.finishLabel.textColor = [UIColor whiteColor];
        self.finishLabel.alpha = 0.9;
        self.finishLabel.shadowOffset = CGSizeMake(0, -1);
        self.finishLabel.shadowColor = [UIColor blackColor];


        self.notWellLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 115, 70, 30)];
        self.notWellLabel.text = @"不靠谱";
        self.notWellLabel.font = [UIFont boldSystemFontOfSize:18];
        self.notWellLabel.backgroundColor = [UIColor clearColor];
        self.notWellLabel.textAlignment = UITextAlignmentLeft;
        self.notWellLabel.textColor = [UIColor whiteColor];
        self.notWellLabel.alpha = 0.9;
        self.notWellLabel.shadowOffset = CGSizeMake(0, -1);
        self.notWellLabel.shadowColor = [UIColor blackColor];

        self.finishRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 73, 120, 30)];
        self.finishRateLabel.textAlignment = UITextAlignmentRight;
        self.finishRateLabel.backgroundColor = [UIColor clearColor];
        self.finishRateLabel.text = @"-";
        self.finishRateLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
        self.finishRateLabel.textColor = [UIColor whiteColor];
        self.finishRateLabel.alpha = 0.9;
        self.finishRateLabel.shadowOffset = CGSizeMake(0, -1);
        self.finishRateLabel.shadowColor = [UIColor blackColor];

        self.notWellRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 113, 120, 30)];
        self.notWellRateLabel.text = @"-";
        self.notWellRateLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
        self.notWellRateLabel.backgroundColor = [UIColor clearColor];
        self.notWellRateLabel.textAlignment = UITextAlignmentRight;
        self.notWellRateLabel.textColor = [UIColor whiteColor];
        self.notWellRateLabel.alpha = 0.9;
        self.notWellRateLabel.shadowOffset = CGSizeMake(0, -1);
        self.notWellRateLabel.shadowColor = [UIColor blackColor];

        [self addSubview:finishLabel];
        [self addSubview:notWellLabel];
        [self addSubview:finishRateLabel];
        [self addSubview:notWellRateLabel];
        [self addSubview:retryButton];
        [self addSubview:nextButton];
        
        self.finishProgress = 0.0;
        self.notRememberWell = 1.0;
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"0.0%;0.0%-0.0%"];
    }
    return self;
}

- (void)retry
{
    NSNotification *notification = [NSNotification notificationWithName:RESTART_LIST object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)next
{
    NSNotification *notification = [NSNotification notificationWithName:NEXT_LIST object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)initWithList:(VSList *)list
{
    self._list = list;
    self.notRememberWellInList = [self._list notWellRate];
    self.finishProgressInList = [self._list finishProgress];
    notRememberWellStep = (1.01 - self.notRememberWellInList) / 20;
    finishProgressStep = (self.finishProgressInList) / 20;
    if (finishProgressStep == 0) {
        finishProgressStep = 0.01;
    }

    self.finishProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateFinishProgress) userInfo:nil repeats:YES];
    self.notRememberWellTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateNotRememberWell) userInfo:nil repeats:YES];
}

- (void)updateFinishProgress
{
    self.finishProgress += finishProgressStep;
    if (self.finishProgress > self.finishProgressInList) {
        self.finishProgress = self.finishProgressInList;
        [self.finishProgressTimer invalidate];
        self.finishProgressTimer = nil;
        int starCount = [self._list rememberRate] / 0.33;
        int originX = 54;
        
        for (int i = 0; i < starCount; i++) {
            UIImageView *starImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"Star"]];
            starImage.frame = CGRectMake(originX, 20, starImage.image.size.width, starImage.image.size.height);
            originX += starImage.image.size.width + 5;
            CGRect originalFrame = starImage.frame;
            CGRect enlargedFrame = CGRectMake(originalFrame.origin.x - 5, originalFrame.origin.y - 5, originalFrame.size.width + 10, originalFrame.size.height + 10);
            [self addSubview:starImage];
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveLinear 
                             animations:^{
                                 starImage.frame = enlargedFrame;
                             }
                             completion:^(BOOL finished) {
                                 if (finished == YES) {
                                     [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveLinear 
                                                      animations:^{
                                                          starImage.frame = originalFrame;
                                                      }
                                                      completion:^(BOOL finished) {
                                                      }
                                      ];
                                 }
                             }
             ];
        }
        for (int i = 0 ; i < 3 - starCount; i++) {
            UIImageView *noStarImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"StarNone"]];
            noStarImage.frame = CGRectMake(originX, 20, noStarImage.image.size.width, noStarImage.image.size.height);
            originX += noStarImage.image.size.width + 5;
            [self addSubview:noStarImage];
        }

    }
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.finishProgress]];
    self.finishRateLabel.text = formattedNumberString;
}


- (void)updateNotRememberWell
{
    self.notRememberWell -= notRememberWellStep;
    if (self.notRememberWell < self.notRememberWellInList) {
        self.notRememberWell = self.notRememberWellInList;
        [self.notRememberWellTimer invalidate];
        self.notRememberWellTimer = nil;
    }
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.notRememberWell]];
    self.notWellRateLabel.text = formattedNumberString;
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
