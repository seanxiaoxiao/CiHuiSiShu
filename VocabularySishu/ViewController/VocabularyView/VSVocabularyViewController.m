//
//  VSVocabularyViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSVocabularyViewController.h"
#import "Reachability.h"
#import "VSUIUtils.h"
#import "VSVocabularyPlayer.h"

@class VSVocabulary;

@interface VSVocabularyViewController ()

@end

@implementation VSVocabularyViewController

@synthesize vocabularyLabel;
@synthesize phoneticLabel;
@synthesize vocabulary;
@synthesize sentenceLabel;
@synthesize imageLabel;
@synthesize vocabularyImageView;
@synthesize scrollView;
@synthesize mwLabel;
@synthesize playButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"DetailsBG"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    UIImage* backImage= [VSUtils fetchImg:@"NavBackButton"];
    CGRect frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height); 
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame]; 
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal]; 
    [backButton addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, 320, [[UIScreen mainScreen] bounds].size.height - 98);
    
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        UIImage* playImage = [VSUtils fetchImg:@"SoundButton"];
        CGRect playFrame = CGRectMake(0, 0, playImage.size.width, playImage.size.height);
        self.playButton = [[UIButton alloc] initWithFrame:playFrame];
        [self.playButton setBackgroundImage:playImage forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* playButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.playButton];
        [self.navigationItem setRightBarButtonItem:playButtonItem];        
    }
    [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(backToList)]];

    self.vocabularyLabel.text = self.vocabulary.spell;
    [self.vocabularyLabel setTextAlignment:UITextAlignmentCenter];
    self.vocabularyLabel.backgroundColor = [UIColor clearColor];
    self.vocabularyLabel.textColor = [UIColor blackColor];
    self.vocabularyLabel.alpha = 0.7f;
    self.vocabularyLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:17];
    self.vocabularyLabel.shadowOffset = CGSizeMake(0, 1);
    self.vocabularyLabel.shadowColor = [UIColor whiteColor];
    if (self.vocabulary.phonetic == nil || [self.vocabulary.phonetic length] == 0) {
        CGPoint center = self.vocabularyLabel.center;
        center.x = 160;
        self.vocabularyLabel.center = center;
        self.phoneticLabel.hidden = YES;
    }
    else {
        self.phoneticLabel.text = [NSString stringWithFormat:@"[%@]", self.vocabulary.phonetic];
        [self.phoneticLabel setTextAlignment:UITextAlignmentCenter];
        self.phoneticLabel.backgroundColor = [UIColor clearColor];
        self.phoneticLabel.textColor = [UIColor blackColor];
        self.phoneticLabel.alpha = 0.7f;
        self.phoneticLabel.font = [UIFont fontWithName:@"Verdana" size:17];
        self.phoneticLabel.shadowOffset = CGSizeMake(0, 1);
        self.phoneticLabel.shadowColor = [UIColor whiteColor];
    }
    int currentHeight = 13;
    if ([self.vocabulary.meanings count] > 0) {
        currentHeight = currentHeight + 5;
        NSString *lastAttr = @"";
        int countInAttr = 0;
        for (VSMeaning *meaning in [self.vocabulary orderedMeanings]) {
            if (![lastAttr isEqualToString:meaning.attribute]) {
                countInAttr = 1;
                UILabel *attrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, currentHeight, 145, 20)];
                lastAttr = meaning.attribute;
                NSRange range = [meaning.attribute rangeOfString:@"（"];
                attrLabel.text = range.location != NSNotFound ? [meaning.attribute substringToIndex:range.location] : meaning.attribute;
                attrLabel.backgroundColor = [UIColor clearColor];
                attrLabel.shadowOffset = CGSizeMake(0, 1);
                attrLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
                currentHeight += 25;
                [self.scrollView addSubview:attrLabel];
            }
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, currentHeight - 4, 30, 30)];
            countLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            countLabel.text = [NSString stringWithFormat:@"%d", countInAttr];
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textAlignment = UITextAlignmentRight;
            countLabel.alpha = 0.8;
            countLabel.shadowOffset = CGSizeMake(0, 1);
            countLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:countLabel];
            UILabel *meaningLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, currentHeight, 262, 30)];
            meaningLabel.text = meaning.meaning;
            meaningLabel.numberOfLines = 0;
            meaningLabel.lineBreakMode = UILineBreakModeCharacterWrap;            
            [meaningLabel sizeToFit];
            meaningLabel.backgroundColor = [UIColor clearColor];
            meaningLabel.shadowOffset = CGSizeMake(0, 1);
            meaningLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:meaningLabel];
            currentHeight = currentHeight + meaningLabel.frame.size.height + 10;
            countInAttr++;
        }
    }
        
    NSArray *sentences = [self.vocabulary sentences];
    int countInSentence = 1;
    if ([sentences count] > 0) {
        self.sentenceLabel.hidden = NO;
        frame = self.sentenceLabel.frame;
        frame.origin.y = currentHeight;
        self.sentenceLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
        
        for (NSDictionary *sentenceInfo in sentences) {
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, currentHeight, 30, 30)];
            countLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            countLabel.text = [NSString stringWithFormat:@"%d", countInSentence++];
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textAlignment = UITextAlignmentRight;
            countLabel.alpha = 0.8;
            countLabel.shadowOffset = CGSizeMake(0, 1);
            countLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:countLabel];
            
            UILabel *sentenceContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, currentHeight, 262, 30)];
            NSString *sentence = [NSString stringWithFormat:@"%@\n%@", [sentenceInfo objectForKey:@"sentence"], [sentenceInfo objectForKey:@"meaning"]];
            NSRange keyWordRange = [sentence rangeOfString:self.vocabulary.spell
                                                   options:(NSCaseInsensitiveSearch | NSRegularExpressionSearch)
                                                     range:NSMakeRange(0, sentence.length -1)];
            if (keyWordRange.location != NSNotFound) {
                NSMutableAttributedString *attributedSentence = [[NSMutableAttributedString alloc] initWithString:sentence];
                [attributedSentence addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHue:0.f saturation:1.f brightness:0.7f alpha:1.f] range:keyWordRange];
                sentenceContentLabel.attributedText = attributedSentence;
            } else {
                sentenceContentLabel.text = sentence;
            }
            
            sentenceContentLabel.numberOfLines = 0;
            sentenceContentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            [sentenceContentLabel sizeToFit];
            sentenceContentLabel.backgroundColor = [UIColor clearColor];
            sentenceContentLabel.lineBreakMode = UILineBreakModeWordWrap;
            sentenceContentLabel.shadowOffset = CGSizeMake(0, 1);
            sentenceContentLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:sentenceContentLabel];
            currentHeight = currentHeight + sentenceContentLabel.frame.size.height + 10;
        }
    }
    
    if ([self.vocabulary.websterMeanings count] > 0) {
        self.mwLabel.hidden = NO;
        CGRect frame = self.mwLabel.frame;
        frame.origin.y = currentHeight + 10;
        self.mwLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 20;
        NSString *lastAttr = @"";
        int countInAttr = 0;
        for (VSWebsterMeaning *meaning in [self.vocabulary orderedWMMeanings]) {
            if (![lastAttr isEqualToString:meaning.attribute]) {
                countInAttr = 1;
                UILabel *attrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, currentHeight, 145, 20)];
                lastAttr = meaning.attribute;
                attrLabel.text = [NSString stringWithFormat:@"%@.", meaning.attribute];
                attrLabel.backgroundColor = [UIColor clearColor];
                attrLabel.font = [UIFont fontWithName:@"Arial" size:18];
                attrLabel.backgroundColor = [UIColor clearColor];
                attrLabel.shadowOffset = CGSizeMake(0, 1);
                attrLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
                currentHeight += 25;
                [self.scrollView addSubview:attrLabel];
            }
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, currentHeight - 4, 30, 30)];
            countLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
            countLabel.text = [NSString stringWithFormat:@"%d", countInAttr];
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textAlignment = UITextAlignmentRight;
            countLabel.alpha = 0.8;
            countLabel.shadowOffset = CGSizeMake(0, 1);
            countLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:countLabel];
            UILabel *meaningLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, currentHeight, 262, 30)];
            meaningLabel.text = meaning.meaning;
            meaningLabel.numberOfLines = 0;
            meaningLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            [meaningLabel sizeToFit];
            meaningLabel.backgroundColor = [UIColor clearColor];
            meaningLabel.lineBreakMode = UILineBreakModeWordWrap;
            meaningLabel.shadowOffset = CGSizeMake(0, 1);
            meaningLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
            [self.scrollView addSubview:meaningLabel];
            currentHeight = currentHeight + meaningLabel.frame.size.height + 10;
            countInAttr++;
        }
    }
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, currentHeight + 50);
    
    self.playButton.hidden = NO;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.vocabularyLabel = nil;
    self.phoneticLabel = nil;
    self.sentenceLabel = nil;
    self.playButton = nil;
    self.vocabulary = nil;
    self.imageLabel = nil;
    self.vocabularyImageView = nil;
    self.scrollView = nil;
    self.mwLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playAudio
{
    __autoreleasing VSVocabularyPlayer *player = [VSVocabularyPlayer getPlayer];
    [player play:self.vocabulary];
}


@end
