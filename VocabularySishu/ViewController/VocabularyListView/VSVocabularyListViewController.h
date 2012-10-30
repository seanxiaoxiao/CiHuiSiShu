//
//  VSVocabularyListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSVocabulary.h"
#import "VSVocabularyListHeaderView.h"
#import "VSConstant.h"
#import "VSList.h"
#import "VSSummaryView.h"
#import "VSVocabularyCell.h"
#import "VSScoreBoardView.h"
#import "TipsBubble.h"


@interface VSVocabularyListViewController : UITableViewController<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableArray *vocabulariesToRecite;
@property (nonatomic, strong) VSVocabularyListHeaderView *headerView;
@property (nonatomic, retain) VSList *listToday;
@property (nonatomic, retain) VSList *currentList;
@property (nonatomic, strong) VSSummaryView *summaryView;
@property (nonatomic, strong) VSVocabularyCell *draggedCell;
@property (nonatomic, strong) VSScoreBoardView *scoreBoardView;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, retain) TipsBubble *vocabularyActionBubble;
@property (nonatomic, retain) TipsBubble *detailBubble;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) int selectedIndex;

@end
