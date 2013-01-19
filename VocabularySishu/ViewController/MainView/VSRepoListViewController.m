//
//  VSRepoListViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepoListViewController.h"
#import "VSUIUtils.h"

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
    self.title = [self.repo titleName];
    self.listViews = [[NSMutableArray alloc] init];
    
    [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(goBack)]];

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
    
    #ifdef TRIAL
        UIImage *listBottomImage = [VSUtils fetchImg:@"List-Bottom"];
        UIImageView *listBottomImageView = [[UIImageView alloc] initWithImage:listBottomImage];
        listBottomImageView.frame = CGRectMake(0, 416 - listBottomImage.size.height, listBottomImage.size.width, listBottomImage.size.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[VSUtils class] action:@selector(openSeries)];
        [listBottomImageView addGestureRecognizer:tap];
        listBottomImageView.userInteractionEnabled = YES;
    
        [self.view addSubview:listBottomImageView];
        [self.view bringSubviewToFront:listBottomImageView];
        UILabel *promoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 379, 200, 16)];
        promoLabel.text = @"Buy It NOW!";
        promoLabel.font = [UIFont boldSystemFontOfSize:16];
        promoLabel.backgroundColor = [UIColor clearColor];
        promoLabel.textColor = [UIColor whiteColor];
        promoLabel.numberOfLines = 0;
        [self.view addSubview:promoLabel];
        [self.view bringSubviewToFront:promoLabel];
    
        UILabel *promoLabelSecnd = [[UILabel alloc] initWithFrame:CGRectMake(15, 394, 200, 20)];
        promoLabelSecnd.text = @"Seeking for C to Z，立即购买完整版";
        promoLabelSecnd.font = [UIFont boldSystemFontOfSize:12];
        promoLabelSecnd.backgroundColor = [UIColor clearColor];
        promoLabelSecnd.textColor = [UIColor whiteColor];
        promoLabelSecnd.numberOfLines = 0;
        [self.view addSubview:promoLabelSecnd];
        [self.view bringSubviewToFront:promoLabelSecnd];
    
    #endif
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
