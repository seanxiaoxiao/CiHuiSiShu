//
//  VSVocabularyViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSVocabularyViewController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "VSUIUtils.h"

@class VSVocabulary;

@interface VSVocabularyViewController ()

@end

@implementation VSVocabularyViewController

@synthesize vocabularyLabel;
@synthesize phoneticLabel;
@synthesize vocabulary;
@synthesize etymologyLabel;
@synthesize etymologyContentLabel;
@synthesize player;
@synthesize imageLabel;
@synthesize vocabularyImageView;
@synthesize scrollView;
@synthesize mwLabel;
@synthesize audioPlayer;
@synthesize backgroundImage;
@synthesize request;
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
    [self.view sendSubviewToBack:self.backgroundImage];
    UIImage* backImage= [VSUtils fetchImg:@"NavBackButton"];
    CGRect frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height); 
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame]; 
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal]; 
    [backButton addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
//    if ([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
//        UIImage* playImage = [VSUtils fetchImg:@"SoundButton"];
//        CGRect playFrame = CGRectMake(0, 0, playImage.size.width, playImage.size.height);
//        self.playButton = [[UIButton alloc] initWithFrame:playFrame];
//        [self.playButton setBackgroundImage:playImage forState:UIControlStateNormal];
//        [self.playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem* playButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.playButton];
//        [self.navigationItem setRightBarButtonItem:playButtonItem];        
//    }
    
    [self.view sendSubviewToBack:self.backgroundImage];
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
    
    currentHeight = currentHeight;
    
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
    
    if (self.vocabulary.etymology != nil && [self.vocabulary.etymology length] > 0) {
        self.etymologyLabel.hidden = NO;
        CGRect frame = self.etymologyLabel.frame;
        frame.origin.y = currentHeight;
        self.etymologyLabel.frame = frame;
        self.etymologyContentLabel.hidden = NO;
        self.etymologyContentLabel.text = self.vocabulary.etymology;
        [self.etymologyContentLabel sizeToFit];
        frame = self.etymologyContentLabel.frame;
        frame.origin.y = currentHeight + 35;
        self.etymologyContentLabel.frame = frame;
        self.etymologyContentLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.etymologyContentLabel.shadowOffset = CGSizeMake(0, 1);
        self.etymologyContentLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];

        currentHeight = currentHeight + frame.size.height + 35;
    }
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, currentHeight + 20);
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
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
    self.etymologyLabel = nil;
    self.playButton = nil;
    self.vocabulary = nil;
    self.player = nil;
    self.imageLabel = nil;
    self.vocabularyImageView = nil;
    self.scrollView = nil;
    self.etymologyContentLabel = nil;
    self.mwLabel = nil;
    self.backgroundImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)play:(id)sender
{
    NSData *fetchedData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:vocabulary.audioLink]];
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    audioPlayer = [[AVAudioPlayer alloc] initWithData:fetchedData error:nil];
    audioPlayer.delegate = self;
    [audioPlayer play];
}

- (void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playAudio
{
    self.request = [ASIHTTPRequest requestWithURL:[self.vocabulary audioURL]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setSecondsToCache:60 * 60 * 24 * 30];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [self.request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [self.request responseData];
    int statusCode = [self.request responseStatusCode];
    
    if (statusCode == 200 || statusCode == 301 || statusCode == 302 || statusCode == 307) {
        NSError *error = [self.request error];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:responseData error:&error];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0f;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    else {
        [self requestFailed:self.request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [self.request error];
    NSLog(@"%@", [error localizedDescription]);
    
}


@end
