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
#import "VSListRecord.h"
#import "VSUtils.h"

@interface VSScoreBoardView : UIView

@property (nonatomic, retain) UIImageView *scoreBoardBackground;
@property (nonatomic, retain) UIButton *retryButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UILabel *notWellLabel;
@property (nonatomic, retain) UILabel *notWellRateLabel;
@property (nonatomic, retain) VSListRecord *_list;
@property (nonatomic, assign) double notRememberWell;
@property (nonatomic, assign) double notRememberWellStep;
@property (nonatomic, assign) double notRememberWellInList;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) NSTimer *notRememberWellTimer;
@property (nonatomic, retain) UIButton *shareButton;
@property (nonatomic, assign) BOOL listFinished;


- (void)initWithList:(VSList *)list;

- (id)initWithFrame:(CGRect)frame finished:(BOOL)isFinish;

@end
