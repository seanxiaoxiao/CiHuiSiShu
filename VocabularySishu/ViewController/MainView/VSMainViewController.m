//
//  VSMainViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSMainViewController.h"
#import "VSMainMenuViewController.h"

@interface VSMainViewController ()

@end

@implementation VSMainViewController

@synthesize navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        VSMainMenuViewController *menuViewController = [[VSMainMenuViewController alloc] initWithNibName:@"VSMainMenuViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
        [self.navigationController.view setFrame: [self.view bounds]];
        [self.view addSubview: navigationController.view];
        menuViewController.navigationController = self.navigationController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navigationController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
