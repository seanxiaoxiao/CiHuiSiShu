//
//  VSMainMenuViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSMainMenuViewController.h"
#import "VSVocabularyListViewController.h"

@interface VSMainMenuViewController ()

@end

@implementation VSMainMenuViewController

@synthesize historyLists;
@synthesize historyTable;

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
    self.title = @"词汇私塾";
    self.historyLists = [VSList lastestHistoryList];
    [self.historyTable reloadData];
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
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSString *predicateContent = [NSString stringWithFormat:@"(name=='GRE顺序List1')"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    VSList *list = [array objectAtIndex:0];
    vocabularyListViewController.currentList = list;
    vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
    [self.navigationController pushViewController:vocabularyListViewController animated:YES];
}

- (IBAction)initData:(id)sender
{
    [VSDataUtil initData];
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
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7 < [self.historyLists count] ? 7 : [self.historyLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSList *list = [historyLists objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [list.objectID description];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = list.name;
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

@end
