//
//  VSGuideViewController.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 8/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSGuideViewController.h"

@interface VSGuideViewController ()

@end

@implementation VSGuideViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize pageControlUsed;
@synthesize lastView;

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

    UIView *guideView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    UIView *guideView2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 460)];
    UIView *guideView3 = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, 460)];
    UIView *guideView4 = [[UIView alloc] initWithFrame:CGRectMake(960, 0, 320, 460)];
    lastView = [[UIView alloc] initWithFrame:CGRectMake(1280, 0, 320, 460)];
    lastView.backgroundColor = [UIColor blackColor];
    
    UIImageView *guidePage1 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage1"]];
    UIImageView *guidePage2 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage2"]];
    UIImageView *guidePage3 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage3"]];
    UIImageView *guidePage4 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage4"]];
    
    [guideView1 addSubview:guidePage1];
    [guideView2 addSubview:guidePage2];
    [guideView3 addSubview:guidePage3];
    [guideView4 addSubview:guidePage4];
   
    
    self.scrollView.contentSize = CGSizeMake(320 * 5, 460);
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:guideView1];
    [self.scrollView addSubview:guideView2];
    [self.scrollView addSubview:guideView3];
    [self.scrollView addSubview:guideView4];
    [self.scrollView addSubview:lastView];
        
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.pageControl = nil;
    self.lastView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)exitGuide
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed) {
        return;
    }
    
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
    if (pageControl.currentPage == 4) {
        [self exitGuide];
    }
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	pageControlUsed = YES;
}

@end
