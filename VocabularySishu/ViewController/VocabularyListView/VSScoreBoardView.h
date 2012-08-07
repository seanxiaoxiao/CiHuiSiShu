//
//  VSScoreBoardView.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "VSList.h"
#import "VSUtils.h"

@interface VSScoreBoardView : UIView

@property (nonatomic, retain) UIImageView *scoreBoardBackground;
@property (nonatomic, retain) UIButton *retryButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UILabel *finishLabel;
@property (nonatomic, retain) UILabel *notWellLabel;
@property (nonatomic, retain) UILabel *finishRateLabel;
@property (nonatomic, retain) UILabel *notWellRateLabel;
@property (nonatomic, retain) VSList *_list;
@property (nonatomic, assign) double finishProgress;
@property (nonatomic, assign) double notRememberWell;
@property (nonatomic, assign) double finishProgressStep;
@property (nonatomic, assign) double notRememberWellStep;
@property (nonatomic, assign) double finishProgressInList;
@property (nonatomic, assign) double notRememberWellInList;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) NSTimer *finishProgressTimer;
@property (nonatomic, retain) NSTimer *notRememberWellTimer;


- (void)initWithList:(VSList *)list;

@end
