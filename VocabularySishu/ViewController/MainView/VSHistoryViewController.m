//
//  VSMainMenuViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSHistoryViewController.h"
#import "VSVocabularyListViewController.h"
#import "MobClick.h"
#import "VSConstant.h"
#import "VSListRecord.h"

@interface VSHistoryViewController ()

@end

@implementation VSHistoryViewController

@synthesize historyLists;
@synthesize historyTable;
@synthesize tableFooterView;
@synthesize activator;
@synthesize loading;
@synthesize startButton;

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
    self.loading = NO;
    self.lastOffset = 0;

    activator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activator.center = CGPointMake(160, 30);
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"Menu"]];
    [self.view addSubview:menuImageView];
    [self.view sendSubviewToBack:menuImageView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 480.0f) {
        CGRect tableFrame = self.historyTable.frame;
        self.historyTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height + 20);
    }
   
#ifdef TRIAL
    UIImage *promoImage = [VSUtils fetchImg:@"MainPromo"];
    UIImageView *promo = [[UIImageView alloc] initWithImage:promoImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[VSUtils class] action:@selector(openSeries)];
    [promo addGestureRecognizer:tap];
    promo.userInteractionEnabled = YES;
    promo.frame = CGRectMake(0, 177, promoImage.size.width, promoImage.size.height);
    [self.view addSubview:promo];
    [self.view bringSubviewToFront:promo];
    
    CGRect tableFrame = self.historyTable.frame;
    self.historyTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + 50, tableFrame.size.width, tableFrame.size.height - 50);
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.historyTable = nil;
    self.startButton = nil;
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

    if ([VSContext isFirstTime]) {
        [self.startButton setTitle:@"开始背诵" forState:UIControlStateNormal];
    }
    else {
        NSString *continueTitle = [NSString stringWithFormat:@"继续背诵 (%@)", [[VSContext getContext].currentList subName]];
        [self.startButton setTitle:continueTitle forState:UIControlStateNormal];
    }
    self.historyLists = [NSMutableArray arrayWithArray:[VSList lastestHistoryList]];
    [self.historyTable reloadData];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recite:(id)sender
{
    [MobClick event:EVENT_ENTER_LIST];
    VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
    VSContext *context = [VSContext getContext];
    VSList *list = context.currentList;
    [list initListRecord];
    vocabularyListViewController.currentList = list;
    vocabularyListViewController.currentListRecord = list.listRecord;
    vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil showBad:NO];
    [self.navigationController pushViewController:vocabularyListViewController animated:YES];
}

- (IBAction)initData:(id)sender
{
    [VSDataUtil initMWMeaning];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:EVENT_ENTER_HISTORY];
    VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
    VSListRecord *selectedList = [historyLists objectAtIndex:indexPath.row];
    vocabularyListViewController.currentListRecord = selectedList;
    vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil showBad:NO];
    [self.navigationController pushViewController:vocabularyListViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loading ? [self.historyLists count] + 1 : [self.historyLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [historyLists count]) {
        NSString *CellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        VSListRecord *list = [historyLists objectAtIndex:indexPath.row];
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.historyLists count] < HISTORY_ITEM_COUNT) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > (scrollView.contentSize.height - scrollView.frame.size.height) + 40 && velocity.y > 0 && !self.loading) {
        self.loading = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.historyLists count] inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.historyTable beginUpdates];
        [self.historyTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.historyTable endUpdates];
        [self.activator startAnimating];
        
        if (self.loading) {
            [self performSelector:@selector(stopAnimatingFooter) withObject:nil afterDelay:0.5];
        }
    }
}

- (void) stopAnimatingFooter
{
    int indexStart = [historyLists count];
    [self.activator stopAnimating];
    self.loading = NO;
    
    [self addMoreList];
    
    [self.historyTable beginUpdates];
    NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:indexStart inSection:0];
    NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:deleteIndexPath, nil];
    [self.historyTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    int indexEnd = [historyLists count];
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < indexEnd - indexStart; i++) {
        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:indexStart + i inSection:0]];
    }
    [self.historyTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.historyTable endUpdates];
}

- (void)addMoreList
{
    if ([self.historyLists count] > 0) {
        NSDate *lastCreatedDate = ((VSListRecord *)[self.historyLists objectAtIndex:[self.historyLists count] - 1]).createdDate;
        [self.historyLists addObjectsFromArray:[VSList historyListBefore:lastCreatedDate]];
    }
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
