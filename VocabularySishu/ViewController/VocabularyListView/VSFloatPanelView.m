//
//  VSFloatPanel.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 12/23/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSFloatPanelView.h"
#import "VSListRecord.h"
#import "VSUtils.h"

@implementation VSFloatPanelView

@synthesize backgroundImageView;
@synthesize wordsCountLabel;
@synthesize planFinishButton;
@synthesize countDownImageView;
@synthesize countDownTimeLabel;
@synthesize wordsTotal;
@synthesize wordsRemain;
@synthesize record;
@synthesize countDownTimer;


- (id)initWithFrame:(CGRect)frame withListRecord:(VSListRecord *)listRecord
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.record = listRecord;
        [self.record resetFinishPlanDate];
        
        UIImage *backgroundImage = [VSUtils fetchImg:@"FloatBar"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        self.backgroundImageView.center = self.center;
        [self addSubview:backgroundImageView];

        self.wordsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 26, 100, 15)];
        self.wordsCountLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.7 alpha:1];
        self.wordsCountLabel.backgroundColor = [UIColor clearColor];
        self.wordsCountLabel.font = [UIFont boldSystemFontOfSize:15];
        self.wordsCountLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:self.wordsCountLabel];
        
        UIImage *planButtonImage = [VSUtils fetchImg:@"FloatBarButton"];
        UIImage *planButtonHighLightedImage = [VSUtils fetchImg:@"FloatBarButtonHighLighted"];
        CGRect planButtonFrame = CGRectMake(180, 17, planButtonImage.size.width, planButtonImage.size.height);
        self.planFinishButton = [[UIButton alloc] initWithFrame:planButtonFrame];
        [self.planFinishButton setTitle:@"计划完成时间" forState:UIControlStateNormal];
        [planFinishButton setBackgroundImage:planButtonImage forState:UIControlStateNormal];
        [planFinishButton setBackgroundImage:planButtonHighLightedImage forState:UIControlStateHighlighted];
        [planFinishButton addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
        self.planFinishButton.titleLabel.shadowColor = [UIColor colorWithHue:0 saturation:0 brightness:0.5 alpha:1];
        self.planFinishButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.planFinishButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];

        [self addSubview:self.planFinishButton];
 
        UIImage *countDownImage = [VSUtils fetchImg:@"FloatBarTimer"];
        self.countDownImageView = [[UIImageView alloc] initWithImage:countDownImage];
        self.countDownImageView.frame = CGRectMake(155, 22, countDownImage.size.width, countDownImage.size.height);
        [self addSubview:self.countDownImageView];

        self.countDownTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 26, 170, 15)];
        self.countDownTimeLabel.backgroundColor = [UIColor clearColor];
        self.countDownTimeLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.7 alpha:1];
        self.countDownTimeLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.countDownTimeLabel];
        
        self.wordsTotal = [self.record wordsTotal];
        
        if (self.record.finishPlanDate != nil) {
            [self startTimer];
        }
        else {
            [self stopTimer];
        }
    }
    return self;
}

- (void)showPickerView
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_PICKER object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)startTimer {
    self.planFinishButton.hidden = YES;
    self.countDownTimeLabel.hidden = NO;
    self.countDownImageView.hidden = NO;
    self.countDownTimer =  [NSTimer scheduledTimerWithTimeInterval: 1
                                                            target: self
                                                          selector: @selector(updateCountDownTime)
                                                          userInfo: nil
                                                           repeats: YES];
}

- (void)stopTimer {
    [self.countDownTimer invalidate];
    self.countDownTimeLabel.hidden = YES;
    self.countDownImageView.hidden = YES;
    self.planFinishButton.hidden = NO;
}

- (void)dismissPickerView
{
    if (self.record.finishPlanDate != nil) {
        [self startTimer];
    }
}

- (void)clearWord
{
    self.wordsRemain = self.wordsRemain - 1;
    [self updateWordsCount];
}

- (void)updateWordsCount
{
    self.wordsCountLabel.text = [NSString stringWithFormat:@"%d / %d", self.wordsRemain, self.wordsTotal];
}

- (void)updateCountDownTime
{
    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval timeToFinish = [self.record.finishPlanDate timeIntervalSinceDate:now];
    int hour = timeToFinish / 60 / 60;
    int minute = (int)timeToFinish % (60 * 60) / 60;
    int second = (int)timeToFinish % (60 * 60) % 60;
    self.countDownTimeLabel.text = [NSString stringWithFormat:@"%d小时%02d分%02d秒", hour, minute, second];
    if (hour == 0 && minute == 0 && second == 0) {
        [self stopTimer];
    }
}

@end
