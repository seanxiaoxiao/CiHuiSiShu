//
//  VSVocabularyViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSUtils.h"
#import "VSList.h"
#import "VSVocabulary.h"
#import "VSMeaning.h"
#import "VSWebsterMeaning.h"
#import "Reachability.h"

@interface VSVocabularyViewController : UIViewController {
    IBOutlet UILabel *vocabularyLabel;
    IBOutlet UILabel *phoneticLabel;
    IBOutlet UILabel *sentenceLabel;
    IBOutlet UILabel *imageLabel;
    IBOutlet UIImageView *vocabularyImageView;
    IBOutlet UILabel *mwLabel;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) UILabel *vocabularyLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UILabel *sentenceLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) VSVocabulary *vocabulary;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UIImageView *vocabularyImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *mwLabel;

@end
