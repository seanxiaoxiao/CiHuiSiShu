//
//  VSVocabularyCell.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/2/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSUtils.h"
#import "VSVocabulary.h"
#import "VSConstant.h"
#import "VSCellStatus.h"

@interface VSVocabularyCell : UITableViewCell

@property (nonatomic, retain) VSVocabulary *_vocabulary;
@property (nonatomic, retain) UILabel *vocabularyLabel;
@property (nonatomic, retain) UILabel *summaryLabel;
@property (nonatomic, retain) UIView *vocabularyContainerView;
@property (nonatomic, retain) UIView *summaryContainerView;
@property (nonatomic, retain) UIImageView *clearImage;
@property (nonatomic, retain) UIImageView *tapeHeadImage;
@property (nonatomic, retain) UIImageView *tapeBodyImage;
@property (nonatomic, retain) UIImageView *tapeTailImage;
@property (nonatomic, retain) UIImageView *lineImage;
@property (nonatomic, retain) UIImageView *cellAccessoryImage;
@property (nonatomic, retain) UIView *clearContainer;
@property (nonatomic, assign) BOOL curlUp;
@property (nonatomic, assign) BOOL curling;
@property (nonatomic, assign) BOOL clearing;
@property (nonatomic, assign) BOOL clearShow;
@property (nonatomic, assign) BOOL hadCurlUp;
@property (nonatomic, assign) CGFloat lastGestureX;
@property (nonatomic, retain) NSTimer *curlUpTimer;
@property (nonatomic, retain) UIImageView *scoreDownImage;
@property (nonatomic, retain) UIImageView *scoreUpImage;
@property (nonatomic, retain) NSDictionary *statusDictionary;


- (void) clearVocabulry:(BOOL)clear;

- (void) dragSummary:(CGFloat)gestureX;

- (void) curlUp:(CGFloat)gestureX;

- (void) curlDown:(CGFloat)gestureX;

- (void) showClearView;

- (void) initWithVocabulary:(VSVocabulary *)vocabulary;

- (void) moveClearView:(CGFloat)gestureX;

- (void) resetStatus;

@end
