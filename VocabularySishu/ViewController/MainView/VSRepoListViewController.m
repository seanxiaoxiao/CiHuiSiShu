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
    self.listViews = [[NSMutableArray alloc] init];
    
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
    int widthIncr = 73.2;
    int height = 20;
    int countInRow = 4;
    if ([self.repo isCategoryRepo]) {
        width = 21.15;
        widthIncr = 99.15;
        height = 20;
        countInRow = 3;
    }
    for (VSList *list in listArray) {
        VSSingleListView *listView = [[VSSingleListView alloc] initWithFrame:CGRectMake(width, height, 50, 80)];
        [listView initWithList:list];
        [self.listViews addObject:listView];
        [self.scrollView addSubview:listView];
        width += widthIncr;
        horizontalCount++;
        if (horizontalCount == countInRow) {
            width = 27.2;
            horizontalCount = 0;
            height += 70;
            if ([self.repo isCategoryRepo]) {
                width = 21.15;
            }
        }
    }
    if (horizontalCount != 0) {
        height += 70;
    }
    self.scrollView.contentSize = CGSizeMake(320, height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    VSContext *context = [VSContext getContext];
    for (VSSingleListView *listView in self.listViews) {
        [listView showStars];
        if (listView.selected == YES) {
            [listView unselectList];
        }
        if ([context.currentList isEqual:listView.theList]) {
            [listView selectList];
        }
    }
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
