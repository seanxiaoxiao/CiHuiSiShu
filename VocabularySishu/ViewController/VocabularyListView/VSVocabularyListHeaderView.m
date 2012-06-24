//
//  VSVocabularyListHeaderView.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyListHeaderView.h"

@implementation VSVocabularyListHeaderView

@synthesize finishRateBar;
@synthesize oftenForgetButton;
@synthesize easyToForgetButton;
@synthesize cannotRememberWellButton;
@synthesize allVocabularyButton;
@synthesize toReciteButton;
@synthesize promptLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishRateBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        [self addSubview:self.finishRateBar];
        oftenForgetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        oftenForgetButton.frame= CGRectMake(6, 15, 60, 30);
        [oftenForgetButton setTitle:@"经常忘记" forState:UIControlStateNormal];
        [oftenForgetButton addTarget:self action:@selector(showOftenForget) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.oftenForgetButton];
        
        easyToForgetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        easyToForgetButton.frame= CGRectMake(68, 15, 60, 30);
        [easyToForgetButton setTitle:@"容易忘记" forState:UIControlStateNormal];
        [easyToForgetButton addTarget:self action:@selector(showEasyToForget) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.easyToForgetButton];
        
        cannotRememberWellButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cannotRememberWellButton.frame= CGRectMake(130, 15, 60, 30);
        [cannotRememberWellButton setTitle:@"模棱两可" forState:UIControlStateNormal];
        [cannotRememberWellButton addTarget:self action:@selector(showCannotRememberWell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cannotRememberWellButton];
        
        allVocabularyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        allVocabularyButton.frame= CGRectMake(192, 15, 60, 30);
        [allVocabularyButton setTitle:@"所有单词" forState:UIControlStateNormal];
        [allVocabularyButton addTarget:self action:@selector(showAllVocabularies) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.allVocabularyButton];
        
        toReciteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        toReciteButton.frame= CGRectMake(254, 15, 60, 30);
        [toReciteButton setTitle:@"等待背诵" forState:UIControlStateNormal];
        [toReciteButton addTarget:self action:@selector(showToRecite) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.toReciteButton];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 260, 20)];
        promptLabel.text = @"尚未背诵";
        [self addSubview:self.promptLabel];
    }
    return self;
}

- (void)showToRecite
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_TORECITE object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    promptLabel.text = @"尚未背诵";    
}

- (void)showAllVocabularies
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_ALL object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    promptLabel.text = @"所有单词";
}

- (void)showCannotRememberWell
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_CANNOTREMEMBERWELL object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    promptLabel.text = @"模棱两可";
}

- (void)showEasyToForget
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_EASYTOFORGET object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    promptLabel.text = @"容易忘记";
}

- (void)showOftenForget
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_OFTENFORGET object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    promptLabel.text = @"经常忘记";
}

- (void)setProgress:(CGFloat)progress
{
    self.finishRateBar.progress = progress;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
