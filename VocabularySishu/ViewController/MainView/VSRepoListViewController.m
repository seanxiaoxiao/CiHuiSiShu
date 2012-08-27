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
    self.title = self.repo.name;

    UIImage* backImage= [VSUtils fetchImg:@"NavBackButton"];
    CGRect frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    NSArray *listArray = [self.repo orderedList];
    int horizontalCount = 0;
    int width = 27.2;
    int height = 20;
    VSContext *context = [VSContext getContext];
    for (VSList *list in listArray) {
        VSSingleListView *listView = [[VSSingleListView alloc] initWithFrame:CGRectMake(width, height, 50, 80)];
        [listView initWithList:list andContext:context];
        [self.scrollView addSubview:listView];
        width += 73.2;
        horizontalCount++;
        if (horizontalCount == 4) {
            width = 27.2;
            horizontalCount = 0;
            height += 70;
        }
    }
    if (horizontalCount != 0) {
        height += 70;
    }
    self.scrollView.contentSize = CGSizeMake(320, height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
