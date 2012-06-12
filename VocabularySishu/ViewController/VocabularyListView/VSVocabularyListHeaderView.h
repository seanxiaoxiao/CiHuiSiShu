//
//  VSVocabularyListHeaderView.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSVocabularyListHeaderView : UIView

@property (nonatomic, strong) UIProgressView *finishRateBar;

- (void)setProgress:(CGFloat)progress;

@end
