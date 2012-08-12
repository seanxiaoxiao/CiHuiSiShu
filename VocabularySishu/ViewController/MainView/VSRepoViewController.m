//
//  VSRepoViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepoViewController.h"

@interface VSRepoViewController ()

@end

@implementation VSRepoViewController
@synthesize repo;
@synthesize repoButton;
@synthesize infoLabel;
@synthesize lastRepo;
@synthesize nextRepo;
@synthesize loaded;

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
    self.repoButton.titleLabel.text = self.repo.name;
    self.infoLabel.text = [NSString stringWithFormat:@"共%d个单词", [self.repo wordsTotal]];
    [self.infoLabel sizeToFit];
    loaded = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadView;
{
    if (!loaded) {
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.repoButton = nil;
    self.infoLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)enterRepos:(id)sender
{
    VSRepoListViewController *controller = [[VSRepoListViewController alloc] initWithNibName:@"VSRepoListViewController" bundle:nil];
    [controller initWithRepo:repo];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [navigationController pushViewController:controller animated:YES];
}

- (void)initWithCurrentRepo:(VSRepository *)current last:(VSRepository *)last next:(VSRepository *)next
{
    self.repo = current;
    self.lastRepo = last;
    self.nextRepo =next;
}

@end
