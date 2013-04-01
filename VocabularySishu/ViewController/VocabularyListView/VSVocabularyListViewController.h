//
//  VSVocabularyListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSVocabulary.h"
#import "VSFloatPanelView.h"
#import "VSConstant.h"
#import "VSList.h"
#import "VSSummaryView.h"
#import "VSVocabularyCell.h"
#import "VSScoreBoardView.h"
#import "TipsBubble.h"

@interface VSVocabularyListViewController : UIViewController<UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSMutableArray *vocabulariesToRecite;
@property (nonatomic, strong) VSFloatPanelView *headerView;
@property (nonatomic, retain) VSListRecord *listToday;
@property (nonatomic, retain) VSList *currentList;
@property (nonatomic, retain) VSListRecord *currentListRecord;
@property (nonatomic, strong) VSSummaryView *summaryView;
@property (nonatomic, strong) VSVocabularyCell *draggedCell;
@property (nonatomic, strong) VSScoreBoardView *scoreBoardView;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, retain) TipsBubble *vocabularyActionBubble;
@property (nonatomic, retain) TipsBubble *detailBubble;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *cellStatus;
@property (nonatomic, assign) int clearingCount;
@property (nonatomic, retain) NSArray *days;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIView *pickerAreaView;
@property (nonatomic, retain) UILabel *promptLabel;


@end
