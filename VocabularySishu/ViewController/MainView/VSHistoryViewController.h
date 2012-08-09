//
//  VSMainMenuViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSDataUtil.h"
#import "VSContext.h"
#import "VSHisotryListCell.h"

@interface VSHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *historyTable;
}

@property (nonatomic, retain) UIView *tableFooterView;
@property (nonatomic, retain) UIActivityIndicatorView *activator;
@property (nonatomic, retain) NSMutableArray *historyLists;
@property (nonatomic, strong) UITableView *historyTable;

- (IBAction)recite:(id)sender;

- (IBAction)initData:(id)sender;

- (void)reloadHistory;

@end
