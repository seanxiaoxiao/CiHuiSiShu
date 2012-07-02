//
//  VSVocabularyViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VSUtils.h"
#import "VSList.h"
#import "VSVocabulary.h"
#import "VSMeaning.h"
#import "FliteTTS.h"


@interface VSVocabularyViewController : UIViewController {
    IBOutlet UILabel *vocabularyLabel;
    IBOutlet UILabel *phoneticLabel;
    IBOutlet UILabel *etymologyLabel;
    IBOutlet UILabel *etymologyContentLabel;
    IBOutlet UIButton *playButton;
    IBOutlet UILabel *meetLabel;
    IBOutlet UILabel *rememberedLabel;
    IBOutlet UILabel *forgotLabel;
    IBOutlet UILabel *greQuizLabel;
    IBOutlet UILabel *gmatQuizLabel;
    IBOutlet UILabel *imageLabel;
    IBOutlet UIImageView *vocabularyImageView;
    IBOutlet UILabel *greQuizContentLabel;
    IBOutlet UILabel *gmatQuizContentLabel;
    IBOutlet UILabel *translationLabel;
    IBOutlet UILabel *translationContentLabel;
    IBOutlet UILabel *mwLabel;
    IBOutlet UILabel *mwContentLabel;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) UILabel *vocabularyLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UILabel *etymologyLabel;
@property (nonatomic, strong) UILabel *etymologyContentLabel;
@property (nonatomic, strong) UILabel *meetLabel;
@property (nonatomic, strong) UILabel *rememberedLabel;
@property (nonatomic, strong) UILabel *forgotLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) VSVocabulary *vocabulary;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UILabel *greQuizLabel;
@property (nonatomic, strong) UILabel *gmatQuizLabel;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UIImageView *vocabularyImageView;
@property (nonatomic, strong) UILabel *greQuizContentLabel;
@property (nonatomic, strong) UILabel *gmatQuizContentLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *translationLabel;
@property (nonatomic, strong) UILabel *translationContentLabel;
@property (nonatomic, strong) UILabel *mwLabel;
@property (nonatomic, strong) UILabel *mwContentLabel;
@property (nonatomic, retain) FliteTTS *fliteEngine;

- (IBAction)play:(id)sender;

@end
