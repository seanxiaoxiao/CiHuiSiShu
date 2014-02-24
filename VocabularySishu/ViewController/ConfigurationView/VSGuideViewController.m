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
    
    offset = 0;
    CGFloat viewHeight = 0;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 480.0f) {
        viewHeight = 548;
    }
    else {
        viewHeight = 460;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        offset = 20;
    }

    lastView = [[UIView alloc] initWithFrame:CGRectMake(1280, offset, 320, viewHeight)];
    lastView.backgroundColor = [UIColor blackColor];
    
    UIImageView *guidePage1 = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"GuidePage1"]];
    guidePage1.frame = CGRectMake(0, guidePage1.frame.origin.y + offset, guidePage1.frame.size.width, guidePage1.frame.size.height);
    UIImageView *guidePage2 = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"GuidePage2"]];
    guidePage2.frame = CGRectMake(320, guidePage2.frame.origin.y + offset, guidePage2.frame.size.width, guidePage2.frame.size.height);
    UIImageView *guidePage3 = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"GuidePage3"]];
    guidePage3.frame = CGRectMake(640, guidePage3.frame.origin.y + offset, guidePage3.frame.size.width, guidePage3.frame.size.height);
    UIImageView *guidePage4 = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"GuidePage4"]];
    guidePage4.frame = CGRectMake(960, guidePage4.frame.origin.y + offset, guidePage4.frame.size.width, guidePage4.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(320 * 5, viewHeight);
    self.scrollView.delegate = self;
    [self.scrollView addSubview:guidePage1];
    [self.scrollView addSubview:guidePage2];
    [self.scrollView addSubview:guidePage3];
    [self.scrollView addSubview:guidePage4];
    [self.scrollView addSubview:lastView];
    
    CGRect pageControlFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50 + offset, 320, 20);
    pageControl.frame = pageControlFrame;
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
    [self dismissModalViewControllerAnimated:YES];
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
