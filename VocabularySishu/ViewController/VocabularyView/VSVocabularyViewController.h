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


@interface VSVocabularyViewController : UIViewController {
    IBOutlet UILabel *vocabularyLabel;
    IBOutlet UILabel *phoneticLabel;
    IBOutlet UILabel *etymologyLabel;
    IBOutlet UIButton *playButton;
    IBOutlet UILabel *meetLabel;
    IBOutlet UILabel *rememberedLabel;
    IBOutlet UILabel *forgotLabel;
}

@property (nonatomic, strong) UILabel *vocabularyLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UILabel *etymologyLabel;
@property (nonatomic, strong) UILabel *meetLabel;
@property (nonatomic, strong) UILabel *rememberedLabel;
@property (nonatomic, strong) UILabel *forgotLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) VSVocabulary *vocabulary;
@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction)play:(id)sender;

@end
