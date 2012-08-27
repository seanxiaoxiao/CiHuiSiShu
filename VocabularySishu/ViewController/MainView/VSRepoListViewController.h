//
//  VSRepoListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSRepository.h"
#import "VSSingleListView.h"
#import "VSList.h"

@interface VSRepoListViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
}

- (void)initWithRepo:(VSRepository *)repository;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) VSRepository *repo;
@property (nonatomic, retain) NSMutableArray *listViews;

@end
