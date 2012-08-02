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
@synthesize etymologyContentLabel;
@synthesize playButton;
@synthesize player;
@synthesize imageLabel;
@synthesize vocabularyImageView;
@synthesize scrollView;
@synthesize translationLabel;
@synthesize translationContentLabel;
@synthesize mwLabel;
@synthesize mwContentLabel;
@synthesize audioPlayer;

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
    self.phoneticLabel.text = [NSString stringWithFormat:@"[%@]", self.vocabulary.phonetic];
    [self.vocabularyLabel sizeToFit];
    [self.phoneticLabel sizeToFit];
    
    int currentHeight = self.scrollView.frame.origin.y - 5;
    if ([self.vocabulary.meanings count] > 0) {
        self.translationLabel.hidden = NO;
        self.translationContentLabel.hidden = NO;
        CGRect frame = self.translationLabel.frame;
        frame.origin.y = currentHeight;
        self.translationLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
        NSMutableString *translation = [NSMutableString stringWithString:@""];
        for (VSMeaning *meaning in [self.vocabulary orderedMeanings]) {
            [translation appendString:meaning.attribute];
            [translation appendString:@" "];
            [translation appendString:meaning.meaning];
            [translation appendString:@"\n"];
        }
        self.translationContentLabel.text = translation;
        [self.translationContentLabel sizeToFit];
        frame = self.translationContentLabel.frame;
        frame.origin.y = currentHeight;
        self.translationContentLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
    }
    
    UIImage *image = [self.vocabulary vocabularyImage];
    if (image != nil) {
        self.imageLabel.hidden = NO;
        self.vocabularyImageView.hidden = NO;
        CGRect frame = self.imageLabel.frame;
        frame.origin.y = currentHeight;
        self.imageLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
        [self.vocabularyImageView setImage:image];
        [self.vocabularyImageView sizeToFit];
        frame = self.vocabularyImageView.frame;
        frame.origin.y = currentHeight;
        self.vocabularyImageView.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
    }
    
    if ([self.vocabulary.websterMeanings count] > 0) {
        self.mwLabel.hidden = NO;
        self.mwContentLabel.hidden = NO;
        CGRect frame = self.mwLabel.frame;
        frame.origin.y = currentHeight;
        self.mwLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
        NSMutableString *mwContent = [NSMutableString stringWithString:@""];
        for (VSWebsterMeaning *meaning in [self.vocabulary orderedWMMeanings]) {
            __autoreleasing NSString *meaningString = [NSString stringWithFormat:@"%@. %@\n", meaning.attribute, meaning.meaning];
            [mwContent appendString:meaningString];
            meaningString = nil;
        }
        self.mwContentLabel.text = mwContent;
        [self.mwContentLabel sizeToFit];
        frame = self.mwContentLabel.frame;
        frame.origin.y = currentHeight;
        self.mwContentLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
    }
    
    if (self.vocabulary.etymology) {
        self.etymologyLabel.hidden = NO;
        self.etymologyContentLabel.hidden = NO;
        CGRect frame = self.etymologyLabel.frame;
        frame.origin.y = currentHeight;
        self.etymologyLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
        self.etymologyContentLabel.text = self.vocabulary.etymology;
        [self.etymologyContentLabel sizeToFit];
        frame = self.etymologyContentLabel.frame;
        frame.origin.y = currentHeight;
        self.etymologyContentLabel.frame = frame;
        currentHeight = currentHeight + frame.size.height + 5;
    }
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, currentHeight + 5);
    
    if ([self.vocabulary hasAudioLink]) {
        self.playButton.hidden = NO;
    }
    else {
        self.playButton.hidden = YES;        
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
    self.imageLabel = nil;
    self.vocabularyImageView = nil;
    self.scrollView = nil;
    self.etymologyContentLabel = nil;
    self.translationLabel = nil;
    self.translationContentLabel = nil;
    self.mwLabel = nil;
    self.mwContentLabel = nil;
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



@end
