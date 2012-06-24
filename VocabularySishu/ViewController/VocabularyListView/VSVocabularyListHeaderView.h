//
//  VSVocabularyListHeaderView.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSConstant.h"

@interface VSVocabularyListHeaderView : UIView

@property (nonatomic, strong) UIProgressView *finishRateBar;
@property (nonatomic, strong) UIButton *oftenForgetButton;
@property (nonatomic, strong) UIButton *easyToForgetButton;
@property (nonatomic, strong) UIButton *cannotRememberWellButton;
@property (nonatomic, strong) UIButton *toReciteButton;
@property (nonatomic, strong) UIButton *allVocabularyButton;
@property (nonatomic, strong) UILabel *promptLabel;

- (void)setProgress:(CGFloat)progress;

@end
