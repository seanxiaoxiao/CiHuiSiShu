//
//  VSMainViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSMainViewController.h"
#import "VSConfigurationViewController.h"

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
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.allRepos count], scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;

    for (int i = 0; i < [allRepos count]; i++) {
        CGRect frame = CGRectMake(i * 320, 0, 320, 416);
        VSRepoViewController *controller = [[VSRepoViewController alloc] initWithNibName:@"VSRepoViewController" bundle:nil];
        [controllers addObject:controller];
        VSRepository *currentRepo = [allRepos objectAtIndex:i];
        VSRepository *lastRepo = i == 0 ? nil : [allRepos objectAtIndex:i - 1];
        VSRepository *nextRepo = i == ([allRepos count] - 1) ? nil : [allRepos objectAtIndex:[allRepos count] - 1];
        [controller initWithCurrentRepo:currentRepo last:lastRepo next:nextRepo];
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
    pageControl.numberOfPages = [self.allRepos count];
    pageControl.currentPage = 0;
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
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
    [[controllers objectAtIndex:page] loadView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changePage:(id)sender
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
