//
//  VSMainMenuViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSHistoryViewController.h"
#import "VSVocabularyListViewController.h"

@interface VSHistoryViewController ()

@end

@implementation VSHistoryViewController

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

    activator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activator.center = CGPointMake(160, 30);

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    if ([VSContext isFirstTime]) {
        [self doRepoSelect];
    }
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
    self.title = @"词汇私塾";
        
    self.historyLists = [NSMutableArray arrayWithArray:[VSList lastestHistoryList]];
    [self.historyTable reloadData];
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
    return 50;
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
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height && ![self.activator isAnimating]) {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
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

- (void)reloadHistory
{
    self.historyLists = [NSMutableArray arrayWithArray:[VSList lastestHistoryList]];
    [self.historyTable reloadData];
}

- (IBAction)toRepoSelect:(id)sender;
{
    [self doRepoSelect];
}

- (void)doRepoSelect
{
    VSMainViewController *mainController = [[VSMainViewController alloc] initWithNibName:@"VSMainViewController" bundle:nil];
    [self.navigationController pushViewController:mainController animated:YES];
}


#pragma mark - setup 

- (IBAction)toConfigurationView:(id)sender
{
    VSConfigurationViewController *configurationViewController = [[VSConfigurationViewController alloc] initWithNibName:@"VSConfigurationViewController" bundle:nil];
    [self.navigationController pushViewController:configurationViewController animated:YES];
}


@end
