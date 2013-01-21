//
//  VSGuideViewController.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 8/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSUtils.h"

@interface VSGuideViewController : UIViewController<UIScrollViewDelegate> {
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *lastView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)exitGuide;

- (IBAction)changePage:(id)sender;

@end
