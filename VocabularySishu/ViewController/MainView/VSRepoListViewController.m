//
//  VSRepoListViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepoListViewController.h"

@interface VSRepoListViewController ()

@end

@implementation VSRepoListViewController
@synthesize repo;
@synthesize scrollView;

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
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    NSArray *listArray = [self.repo orderedList];
    int horizontalCount = 0;
    int width = 15;
    int height = 20;
    for (VSList *list in listArray) {
        VSSingleListView *listView = [[VSSingleListView alloc] initWithFrame:CGRectMake(width, height, 50, 80)];
        [listView initWithList:list];
        [self.scrollView addSubview:listView];
        width += 60;
        horizontalCount++;
        if (horizontalCount == 5) {
            width = 15;
            horizontalCount = 0;
            height += 70;
        }
    }
    self.scrollView.contentSize = CGSizeMake(320, height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.repo.name;
}

- (void)initWithRepo:(VSRepository *)repository
{
    self.repo = repository;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
