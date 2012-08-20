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
@synthesize activityIndicator;
@synthesize repoNameLabel;
@synthesize listCountLabel;

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
    CGPoint center = self.view.center;

    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    center.y = 270;
    activityIndicator.center = center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self.view bringSubviewToFront:activityIndicator];
    
    UIImage *repoImage = [repo repoImage];
    self.repoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, repoImage.size.width, repoImage.size.height)];
    center.y = 155;
    [self.repoButton setBackgroundImage:repoImage forState:UIControlStateNormal];
    self.repoButton.center = center;
    [self.repoButton addTarget:self action:@selector(enterRepos) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.repoButton];
    
    self.repoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, 80, 80)];
    self.repoNameLabel.numberOfLines = 0;
    self.repoNameLabel.text = self.repo.name;
    self.repoNameLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.repoNameLabel.font = [UIFont boldSystemFontOfSize:22];
    self.repoNameLabel.textColor = [self.repo repoNameColor];
    self.repoNameLabel.backgroundColor = [UIColor clearColor];
    self.repoNameLabel.shadowColor = [UIColor blackColor];
    self.repoNameLabel.shadowOffset = CGSizeMake(0, 2);
    self.repoNameLabel.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:self.repoNameLabel];
    [self.view bringSubviewToFront:self.repoNameLabel];

}

- (void)loadRepoView;
{
    if ([self.activityIndicator isAnimating]) {
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 255, 130, 20)];
        self.infoLabel.text = [NSString stringWithFormat:@"共%d个单词", [self.repo wordsTotal]];
        self.infoLabel.font = [UIFont boldSystemFontOfSize:14];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor colorWithHue:45.0/360.0 saturation:0.2 brightness:1 alpha:0.9];
        self.infoLabel.shadowColor = [UIColor blackColor];
        self.infoLabel.textAlignment = UITextAlignmentCenter;
        self.infoLabel.shadowOffset = CGSizeMake(0, 2);
        
        self.listCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 280, 130, 20)];
        self.listCountLabel.text = [NSString stringWithFormat:@"%d个单词列表", [self.repo.lists count]];
        self.listCountLabel.font = [UIFont boldSystemFontOfSize:14];
        self.listCountLabel.backgroundColor = [UIColor clearColor];
        self.listCountLabel.textColor = [UIColor colorWithHue:45.0/360.0 saturation:0.2 brightness:1 alpha:0.9];
        self.listCountLabel.shadowColor = [UIColor blackColor];
        self.listCountLabel.textAlignment = UITextAlignmentCenter;
        self.listCountLabel.shadowOffset = CGSizeMake(0, 2);
        
        [self.view addSubview:self.infoLabel];
        [self.view addSubview:self.listCountLabel];
        
        [self.activityIndicator stopAnimating];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.repoButton = nil;
    self.infoLabel = nil;
    self.repoNameLabel = nil;
    self.activityIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)enterRepos
{
    VSRepoListViewController *controller = [[VSRepoListViewController alloc] initWithNibName:@"VSRepoListViewController" bundle:nil];
    [controller initWithRepo:repo];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [navigationController pushViewController:controller animated:YES];
}

- (void)initWithCurrentRepo:(VSRepository *)current
{
    self.repo = current;
}

@end
