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
@synthesize exitButton;

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
    UIView *guideView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    UIView *guideView2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 460)];
    UIView *guideView3 = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 320, 460)];
    
    UIImageView *guidePage1 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage1"]];
    UIImageView *guidePage2 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage2"]];
    UIImageView *guidePage3 = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"GuidePage3"]];
    
    [guideView1 addSubview:guidePage1];
    [guideView2 addSubview:guidePage2];
    [guideView3 addSubview:guidePage3];
    
    self.scrollView.contentSize = CGSizeMake(320 * 3, 460);
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:guideView1];
    [self.scrollView addSubview:guideView2];
    [self.scrollView addSubview:guideView3];
    
    UIImage *normalButtonImage = [VSUtils fetchImg:@"ButtonBT"];
    UIImage *highlightButtonImage = [VSUtils fetchImg:@"ButtonBTHighLighted"];
    
    self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 390, normalButtonImage.size.width, normalButtonImage.size.height)];
    self.exitButton.center = CGPointMake(160, 400);
    [self.exitButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
    [self.exitButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
    [self.exitButton setTitle:@"开始" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitGuide) forControlEvents:UIControlEventTouchUpInside];
    self.exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.exitButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.exitButton.titleLabel.shadowColor = [UIColor blackColor];
    
    [guideView3 addSubview:self.exitButton];
    
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)exitGuide
{
    [self.navigationController popViewControllerAnimated:YES];
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
