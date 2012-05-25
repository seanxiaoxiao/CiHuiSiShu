//
//  VSVocabularyListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSVocabulary.h"
#import "VSMeaningCell.h"
#import "VSVocabularyListHeaderView.h"

@interface VSVocabularyListViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *vocabulariesToRecite;
@property (nonatomic, retain) VSVocabulary *selectedVocabulary;
@property (nonatomic, assign) CGFloat meaningCellHeight;
@property (nonatomic, strong) VSVocabularyListHeaderView *headerView;
@property (nonatomic, strong) UIView *draggedView;

@end
