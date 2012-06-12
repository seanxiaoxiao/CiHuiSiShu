//
//  VSVocabularyViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSVocabularyViewController.h"

@class VSVocabulary;

@interface VSVocabularyViewController ()

@end

@implementation VSVocabularyViewController

@synthesize vocabularyLabel;
@synthesize phoneticLabel;
@synthesize vocabulary;
@synthesize etymologyLabel;
@synthesize playButton;
@synthesize player;
@synthesize meetLabel;
@synthesize rememberedLabel;
@synthesize forgotLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.vocabulary.spell; //[context fetchCurrentList].name;
    self.vocabularyLabel.text = self.vocabulary.spell;
    self.phoneticLabel.text = self.vocabulary.phonetic;
    self.etymologyLabel.text = self.vocabulary.etymology;
    self.meetLabel.text = [self.vocabulary meetTimes];
    self.rememberedLabel.text = [self.vocabulary rememberedTimes];
    self.forgotLabel.text = [self.vocabulary forgotTimes];
    [self.vocabularyLabel sizeToFit];
    [self.phoneticLabel sizeToFit];
    [self.etymologyLabel sizeToFit];
    if (![self audioExist]) {
        [self.playButton setHidden:YES];
    }
    else {
        [self.playButton setHidden:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.vocabularyLabel = nil;
    self.phoneticLabel = nil;
    self.etymologyLabel = nil;
    self.playButton = nil;
    self.vocabulary = nil;
    self.player = nil;
    self.meetLabel = nil;
    self.rememberedLabel = nil;
    self.forgotLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)play:(id)sender
{
    NSURL *pathURL = [self audioPath:self.vocabulary.spell];
    NSData *objectData = [NSData dataWithContentsOfURL:pathURL];
    NSLog(@"%@", objectData);
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:objectData error:&error];
    [self.player prepareToPlay];
    [self.player play];
}

- (BOOL)audioExist
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.vocabulary.spell withExtension: @"mp3"];
    return url != nil;
}

- (NSURL *)audioPath:(NSString *)spell
{
    return [[NSBundle mainBundle] URLForResource:self.vocabulary.spell withExtension: @"bin"];
}


@end
