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
@synthesize loading;

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
    loading = NO;

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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"词汇私塾";
    
    UIImage* image= [VSUtils fetchImg:@"infoButton"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* infoButton = [[UIButton alloc] initWithFrame:frame];
    [infoButton setBackgroundImage:image forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(toConfigurationView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.navigationItem setRightBarButtonItem:infoButtonItem];

    
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

    return loading ? [self.historyLists count] + 1 : [self.historyLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [historyLists count]) {
        VSList *list = [historyLists objectAtIndex:indexPath.row];
        NSString *CellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[VSHisotryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [((VSHisotryListCell *)(cell)) initWithList:list andRow:indexPath.row];
        return cell;
    }
    else {
        NSString *CellIdentifier = @"LoadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.contentView addSubview:self.activator];
        }
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (([scrollView contentOffset].y + scrollView.frame.size.height) == [scrollView contentSize].height && ![self.activator isAnimating]) {
        self.loading = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[historyLists count] inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.historyTable insertRowsAtIndexPaths: indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.activator startAnimating];
        [self performSelector:@selector(stopAnimatingFooter) withObject:nil afterDelay:0.5];
	}
}

- (void) stopAnimatingFooter
{
    int indexStart = [historyLists count];
    [self.activator stopAnimating];
    self.loading = NO;
    [self.historyTable beginUpdates];
    NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:indexStart inSection:0];
    NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:deleteIndexPath, nil];
    [self.historyTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self addMoreList];
    int indexEnd = [historyLists count];
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < indexEnd - indexStart; i++) {
        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:indexStart + i inSection:0]];
    }
    [self.historyTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.historyTable endUpdates];
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
