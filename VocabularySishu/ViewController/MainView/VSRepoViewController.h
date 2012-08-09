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
    IBOutlet UIButton *repoButton;
    IBOutlet UILabel *infoLabel;
}

@property (nonatomic, strong) UIButton *repoButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, retain) VSRepository *repo;
@property (nonatomic, retain) VSRepository *lastRepo;
@property (nonatomic, retain) VSRepository *nextRepo;

- (IBAction)enterRepos:(id)sender;

- (void)initWithCurrentRepo:(VSRepository *)current last:(VSRepository *)last next:(VSRepository *)next;

@end
