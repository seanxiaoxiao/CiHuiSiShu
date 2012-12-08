//
//  VSRepoViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSRepository.h"
#import "VSRepoListViewController.h"

@interface VSRepoViewController : UIViewController {

}

@property (nonatomic, retain) UIButton *repoButton;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) VSRepository *repo;
@property (nonatomic, retain) UILabel *repoNameLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)initWithCurrentRepo:(VSRepository *)current;

@end
