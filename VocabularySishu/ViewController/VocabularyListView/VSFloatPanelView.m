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
@synthesize wordsCountImageView;
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
        
        UIImage *backgroundImage = [VSUtils fetchImg:@""];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        [self addSubview:backgroundImageView];
        
        UIImage *wordsCountImage = [VSUtils fetchImg:@""];
        self.wordsCountImageView = [[UIImageView alloc] initWithImage:wordsCountImage];
        self.wordsCountImageView.frame = CGRectMake(20, 10, wordsCountImage.size.width, wordsCountImage.size.height);
        [self addSubview:self.wordsCountImageView];
        
        self.wordsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 44)];
        self.wordsCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.wordsCountLabel];
        
        UIImage *planButtonImage = [VSUtils fetchImg:@""];
        CGRect planButtonFrame = CGRectMake(150, 10, planButtonImage.size.width, planButtonImage.size.height);
        self.planFinishButton = [[UIButton alloc] initWithFrame:planButtonFrame];
        self.planFinishButton.titleLabel.text = @"设定背诵完成期限";
        [planFinishButton setBackgroundImage:planButtonImage forState:UIControlStateNormal];
        [planFinishButton addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.planFinishButton];
 
        UIImage *countDownImage = [VSUtils fetchImg:@""];
        self.countDownImageView = [[UIImageView alloc] initWithImage:countDownImage];
        self.countDownImageView.frame = CGRectMake(120, 10, countDownImage.size.width, countDownImage.size.height);
        [self addSubview:self.countDownImageView];

        self.countDownTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 44)];
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
    self.wordsCountLabel.text = [NSString stringWithFormat:@"%d/%d", self.wordsRemain, self.wordsTotal];
}

- (void)updateCountDownTime
{
    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval timeToFinish = [self.record.finishPlanDate timeIntervalSinceDate:now];
    double hour = timeToFinish / 60 / 60;
    double minute = timeToFinish / 60 / 60 / 60;
    double second = (int)timeToFinish / 60 / 60 % 60;
    self.countDownTimeLabel.text = [NSString stringWithFormat:@"%f小时%f分%f秒", hour, minute, second];
    if (hour == 0 && minute == 0 && second == 0) {
        [self stopTimer];
    }
}

@end
