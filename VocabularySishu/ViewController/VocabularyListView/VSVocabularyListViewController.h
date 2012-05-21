//
//  VSVocabularyListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VSVocabularyListViewController : UITableViewController

@property (nonatomic, retain) NSArray *listVocabularies;
@property (nonatomic, strong) UIProgressView *finishProgress;

@end
