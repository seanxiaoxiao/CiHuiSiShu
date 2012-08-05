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
#import "VSWebsterMeaning.h"


@interface VSVocabularyViewController : UIViewController<AVAudioPlayerDelegate> {
    IBOutlet UILabel *vocabularyLabel;
    IBOutlet UILabel *phoneticLabel;
    IBOutlet UILabel *etymologyLabel;
    IBOutlet UILabel *etymologyContentLabel;
    IBOutlet UIButton *playButton;
    IBOutlet UILabel *imageLabel;
    IBOutlet UIImageView *vocabularyImageView;
    IBOutlet UILabel *mwLabel;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *backgroundImage;
}

@property (nonatomic, strong) UILabel *vocabularyLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UILabel *etymologyLabel;
@property (nonatomic, strong) UILabel *etymologyContentLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) VSVocabulary *vocabulary;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UIImageView *vocabularyImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *mwLabel;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIImageView *backgroundImage;

- (IBAction)play:(id)sender;

@end
