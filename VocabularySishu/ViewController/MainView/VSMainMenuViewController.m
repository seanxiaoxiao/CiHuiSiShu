//
//  VSMainMenuViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSMainMenuViewController.h"
#import "VSConfigurationViewController.h"
#import "VSVocabularyListViewController.h"

@interface VSMainMenuViewController ()

@end

@implementation VSMainMenuViewController

@synthesize historyLists;
@synthesize historyTable;
@synthesize tableFooterView;
@synthesize activator;

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
    self.title = @"词汇私塾";
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.historyTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect frame= CGRectMake(0, 0, 20, 20); 
    UIButton* configurationButton = [[UIButton alloc] initWithFrame:frame]; 
    [configurationButton setTitle:@"设置" forState:UIControlStateNormal]; 
    [configurationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    configurationButton.titleLabel.font=[UIFont boldSystemFontOfSize:10];
    configurationButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [configurationButton addTarget:self action:@selector(toConfigurationView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* configurationButtonItem = [[UIBarButtonItem alloc] initWithCustomView:configurationButton]; 
    [self.navigationItem setRightBarButtonItem:configurationButtonItem];

    self.historyLists = [NSMutableArray arrayWithArray:[VSList lastestHistoryList]];
    [self.historyTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recite:(id)sender
{
    VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
    VSContext *context = [VSContext getContext];
    VSList *list = context.currentList;
    vocabularyListViewController.currentList = list;
    vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
    [self.navigationController pushViewController:vocabularyListViewController animated:YES];
}

- (IBAction)initData:(id)sender
{
    [VSDataUtil initMWMeaning];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
    VSList *selectedList = [historyLists objectAtIndex:indexPath.row];
    vocabularyListViewController.currentList = selectedList;
    vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
    [self.navigationController pushViewController:vocabularyListViewController animated:YES]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSList *list = [historyLists objectAtIndex:indexPath.row];
    NSString *CellIdentifier = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VSHisotryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [((VSHisotryListCell *)(cell)) initWithList:list andRow:indexPath.row];
    BOOL lastCell = indexPath.row == [self.historyLists count] - 1;
    if (lastCell) {
        [((VSHisotryListCell *)(cell)) addCellShadow];
    }
    else {
        [((VSHisotryListCell *)(cell)) removeCellShadow];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height) {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
        activator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activator.center = CGPointMake(160, 30);
        [tableFooterView addSubview:activator];
        self.historyTable.tableFooterView = tableFooterView;
        [self.activator startAnimating];
        [self performSelector:@selector(stopAnimatingFooter) withObject:nil afterDelay:0.5];
	}
}

- (void) stopAnimatingFooter
{
    [self.activator stopAnimating];
    self.historyTable.tableFooterView = nil;
    [self addMoreList];
    [self.historyTable reloadData];
}

- (void) addMoreList
{
    NSDate *lastCreatedDate = ((VSList *)[self.historyLists objectAtIndex:[self.historyLists count] - 1]).createdDate;
    [self.historyLists addObjectsFromArray:[VSList historyListBefore:lastCreatedDate]];
}

#pragma mark - setup 

- (void)toConfigurationView
{
    VSConfigurationViewController *configurationViewController = [[VSConfigurationViewController alloc] initWithNibName:@"VSConfigurationViewController" bundle:nil];
    [self.navigationController pushViewController:configurationViewController animated:YES];
}

@end
