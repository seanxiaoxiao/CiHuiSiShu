//
//  VSMainViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSMainViewController.h"
#import "VSConfigurationViewController.h"
#import "VSClipView.h"

@interface VSMainViewController ()

@end

@implementation VSMainViewController
@synthesize scrollView, pageControl, allRepos, pageIndex, pageControlUsed, controllers;

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
    
    self.controllers = [[NSMutableArray alloc] init];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    self.allRepos = [VSRepository allRepos];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(205 * [self.allRepos count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.clipsToBounds = NO;
    
    VSClipView *clipView = [[VSClipView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, 320 - self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    clipView.scrollView = scrollView;
    [self.view addSubview:clipView];

    int selected = -1;
    VSRepository *repo = [VSContext getContext].currentRepository;
    for (int i = 0; i < [allRepos count]; i++) {
        CGRect frame = CGRectMake(i * 205, 0, 205, 416);
        VSRepoViewController *controller = [[VSRepoViewController alloc] initWithNibName:nil bundle:nil];
        [controllers addObject:controller];
        VSRepository *currentRepo = [allRepos objectAtIndex:i];
        [controller initWithCurrentRepo:currentRepo];
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        if ([repo isEqual:currentRepo]) {
            selected = i;
        }
    }
    pageControl.numberOfPages = [self.allRepos count];
    pageControl.currentPage = 0;
    if (selected != -1) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * selected;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
        pageControl.currentPage = selected;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[controllers objectAtIndex:pageControl.currentPage] loadRepoView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"选择词库";
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed) {
        return;
    }

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
    [[controllers objectAtIndex:pageControl.currentPage] loadRepoView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
