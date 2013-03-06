//
//  VSFloatPanel.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 12/23/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSListRecord;

@interface VSFloatPanelView : UIView

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UILabel *wordsCountLabel;
@property (nonatomic, retain) UIButton *planFinishButton;
@property (nonatomic, retain) UIImageView *countDownImageView;
@property (nonatomic, retain) UILabel *countDownTimeLabel;
@property (nonatomic, assign) int wordsTotal;
@property (nonatomic, assign) int wordsRemain;
@property (nonatomic, retain) VSListRecord *record;
@property (nonatomic, retain) NSTimer* countDownTimer;

- (id)initWithFrame:(CGRect)frame withListRecord:(VSListRecord *)listRecord showBad:(BOOL)showBad;

- (void)clearWord;

- (void)updateWordsCount;

- (void)startTimer;

@end
