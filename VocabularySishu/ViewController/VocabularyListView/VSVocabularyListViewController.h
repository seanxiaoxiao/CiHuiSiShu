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
#import "FDCurlViewControl.h"
#import "VSRememberedList.h"

@interface VSVocabularyListViewController : UIViewController<UIGestureRecognizerDelegate, FDCurlViewControlDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UIView *containerView;
    IBOutlet UIButton *planFinishButton;
    IBOutlet UILabel *planFinishLabel;
    IBOutlet UIButton *revertButton;
}

@property (nonatomic, retain) NSMutableArray *vocabulariesToRecite;
@property (nonatomic, strong) VSVocabularyListHeaderView *headerView;
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
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, retain) FDCurlViewControl *curlButton;
@property (nonatomic, strong) UIButton *planFinishButton;
@property (nonatomic, retain) NSArray *days;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *planFinishLabel;
@property (nonatomic, strong) UIButton *revertButton;
@property (nonatomic, retain) VSRememberedList *rememberedList;
@property (nonatomic, assign) BOOL inRevert;

- (IBAction)curlUp:(id)sender;

- (IBAction)revertToken:(id)sender;

@end
