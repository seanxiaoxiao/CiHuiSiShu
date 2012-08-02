//
//  VSConfigurationViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 6/15/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSConfigurationViewController.h"

@interface VSConfigurationViewController ()

@end

@implementation VSConfigurationViewController

@synthesize listSelectRecords;
@synthesize selectedListIndex;
@synthesize selectedRepoIndex;
@synthesize selectedRepo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initListSelectRecords];
    self.title = @"设置";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.listSelectRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *record = [self.listSelectRecords objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    VSContext *context = [VSContext getContext];
    if ([record class] == [VSRepository class]) {
        VSRepository *repository = (VSRepository *)record;
        NSString *cellIdentifier = repository.name;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            selectedListIndex = indexPath.row;
        }
        cell.textLabel.text = repository.name;
        [cell.textLabel setTextAlignment:UITextAlignmentLeft];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        VSList *list  = (VSList *)record;
        NSString *cellIdentifier = list.name;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = list.name;
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        if ([context.currentList.name isEqualToString:list.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectedListIndex = indexPath.row;
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *selectedRecord = [listSelectRecords objectAtIndex:indexPath.row];
    VSContext *context = [VSContext getContext];
    if ([selectedRecord class] == [VSList class]) {
        VSList *selectedList = (VSList *)selectedRecord;
        [context fixCurrentList:selectedList];
        [context fixRepository:selectedList.repository];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForRow:self.selectedListIndex inSection:indexPath.section];
        UITableViewCell *lastSelectedCell = [self.tableView cellForRowAtIndexPath:lastSelectedIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedListIndex = indexPath.row;
    }
    else if (selectedRepoIndex != indexPath.row && [selectedRecord class] == [VSRepository class]) {
        selectedRepo = (VSRepository *)selectedRecord;
        [self contractRepo];
        VSContext *context = [VSContext getContext];
        [context fixRepository:selectedRepo];
        [context fixCurrentList:[selectedRepo firstListInRepo]];
        [self expandRepo];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRepoIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)contractRepo {
    NSMutableArray *removeIndexArray = [NSMutableArray array];
    int count = [listSelectRecords count];
    for (int i = selectedRepoIndex + 1; i < count; i++) {
        NSObject *selectedRecord = [listSelectRecords objectAtIndex:selectedRepoIndex + 1];
        if ([selectedRecord class] == [VSRepository class]) {
            break;
        }
        else {
            [listSelectRecords removeObjectAtIndex:selectedRepoIndex + 1];
            [removeIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:removeIndexArray withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)expandRepo {
    NSMutableArray *insertIndexArray = [NSMutableArray array];
    for (int i = 0; i < [listSelectRecords count]; i++) {
        VSRepository *repo = [listSelectRecords objectAtIndex:i];
        if ([repo isEqual:selectedRepo]) {
            NSArray *listsInRepo = [repo orderedList];
            for (int j = 0; j < [listsInRepo count]; j++) {
                [listSelectRecords insertObject:[listsInRepo objectAtIndex:j] atIndex:i + j + 1];
                [insertIndexArray addObject:[NSIndexPath indexPathForRow:i + j + 1 inSection:0]];
            }
            selectedRepoIndex = i;
        }
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexArray withRowAnimation:UITableViewScrollPositionBottom];
    [self.tableView endUpdates];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = @"选择背诵列表";
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0) saturation:1.0 brightness:0.60 alpha:1.0];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    
    return view;
}

#pragma mark - Private methods

- (void)initListSelectRecords
{
    self.listSelectRecords = [[NSMutableArray alloc] init];
    VSContext *context = [VSContext getContext];
    NSArray *rawRepos = [VSRepository allRepos];
    for (int i = 0; i < [rawRepos count]; i ++) {
        VSRepository *repo = [rawRepos objectAtIndex:i];
        [self.listSelectRecords addObject:repo];
        NSArray *listsInRepo = [repo orderedList];
        if ([context.currentRepository isEqual:repo]) {
            selectedRepoIndex = i;
            for (VSList *list in listsInRepo) {
                [self.listSelectRecords addObject:list];
            }
        }
    }
}

@end
