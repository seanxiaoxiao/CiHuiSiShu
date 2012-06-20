//
//  VSMeaningView.h
//  VocabularySishu
//
//  Created by xiao xiao on 6/18/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSMeaning.h"
#import "VSVocabulary.h"

@interface VSMeaningView : UIView<UIWebViewDelegate>

@property (nonatomic, retain) NSArray *_meanings;
@property (nonatomic, retain) UIWebView *meaningView;
@property (nonatomic, retain) UIButton *detailButton;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, retain) VSVocabulary *meaningFor;

- (void)setMeaningContent:(NSArray *)meanings;

@end
