//
//  VSVocabularyViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSVocabularyViewController.h"
#import "Vocabulary.h"
#import "VSUtils.h"

@interface VSVocabularyViewController ()

@end

@implementation VSVocabularyViewController

@synthesize vocabularyLabel;
@synthesize phoneticLabel;
@synthesize navigationController;

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
    self.navigationController.navigationItem.title = @"GRE顺序List 1";
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)randomClick:(id)sender
{
    Vocabulary *newVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    newVocabulary.spell = @"apple";
    newVocabulary.meet = [NSNumber numberWithInt:0];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    NSLog(@"No problem?");
}



@end
