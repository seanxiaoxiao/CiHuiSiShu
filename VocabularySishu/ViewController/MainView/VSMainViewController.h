//
//  VSMainViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSRepository.h"
#import "VSRepoViewController.h"
#import "VSList.h"
#import "VSHistoryViewController.h"
#import "VSUtils.h"

@interface VSMainViewController : UIViewController<UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
}

- (void)changePage:(id)sender;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *allRepos;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, strong) NSMutableArray *controllers;

@end
