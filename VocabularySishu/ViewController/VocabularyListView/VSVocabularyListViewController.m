//
//  VSVocabularyListViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyListViewController.h"
#import "VSVocabularyViewController.h"
#import "VSUtils.h"
#import "VSContext.h"
#import "VSListVocabulary.h"
#import "VSMeaning.h"


@interface VSVocabularyListViewController ()

@end

@implementation VSVocabularyListViewController

@synthesize vocabulariesToRecite;
@synthesize headerView;
@synthesize listToday;
@synthesize summaryView;
@synthesize touchPoint;
@synthesize draggedCell;
@synthesize countInList;
@synthesize rememberCount;
@synthesize selectedIndex;
@synthesize draggedIndex;
@synthesize currentList;
@synthesize alertWhenFinish;
@synthesize alertDelegate;
@synthesize reviewPlan;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        UIImage *backbutton = [VSUtils fetchImg:@"back-buttom.png"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = self.currentList.name;
        self.headerView = [[VSVocabularyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        self.tableView.tableHeaderView = headerView;
        [self.headerView updateProgress:[self.currentList finishProgress]];
        self.vocabulariesToRecite = [NSMutableArray arrayWithArray:[self.currentList vocabulariesToRecite]];
        if ([self.vocabulariesToRecite count] == 0) {
            [self.tableView removeFromSuperview];
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
            [backgroundImageView setFrame:self.view.frame];
            [self.view addSubview:backgroundImageView];
            [self.view sendSubviewToBack:backgroundImageView];
            UIImage *restartImage = [VSUtils fetchImg:@"Restart"];
            UIButton *restartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, restartImage.size.width, restartImage.size.height)];
            [restartButton setImage:restartImage forState:UIControlStateNormal];
            [restartButton setImage:[VSUtils fetchImg:@"Restart-Highlight"] forState:UIControlStateHighlighted];
            [restartButton addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:restartButton];
            restartButton.center = self.view.center;
        }
        else {
            self.reviewPlan = [VSReviewPlan getPlan];
            if (![currentList isHistoryList]) {
                self.listToday = [VSList createAndGetHistoryList];
            }
            [currentList process];
            self.countInList = [self.currentList.listVocabularies count];
            self.rememberCount = [self.currentList rememberedCount];
            self.selectedIndex = -1;
            
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
            [backgroundImageView setFrame:self.tableView.frame];
        
            self.tableView.backgroundView = backgroundImageView;
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailView) name:SHOW_DETAIL_VIEW object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearVocabulary:) name:CLEAR_VOCABULRY object:nil];

            __autoreleasing UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
            panGesture.delegate = self;
            [self.view addGestureRecognizer:panGesture];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIImage* image= [VSUtils fetchImg:@"back-button"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height); 
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame]; 
    [backButton setBackgroundImage:image forState:UIControlStateNormal]; 
    [backButton setTitle:@" 词汇私塾" forState:UIControlStateNormal]; 
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    backButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.alertDelegate = [[VSAlertDelegate alloc] init];
    self.alertDelegate.currentList = currentList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.currentList isHistoryList]) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 83, 44.01)];
        rightView.backgroundColor = [UIColor clearColor];
    
        UIImage* previousImage = [VSUtils fetchImg:@"Previous"];
        CGRect previousFrame = CGRectMake(0, 0, previousImage.size.width, previousImage.size.height); 
        UIButton* previousButton = [[UIButton alloc] initWithFrame:previousFrame]; 
        [previousButton setBackgroundImage:previousImage forState:UIControlStateNormal];
        [previousButton addTarget:self action:@selector(previousList) forControlEvents:UIControlEventTouchUpInside];
        if ([self.currentList isFirst]) {
            [previousButton setEnabled:NO];
        }
        [rightView addSubview:previousButton];

        UIImage* nextImage = [VSUtils fetchImg:@"Next"];
        CGRect nextFrame = CGRectMake(44, 0, nextImage.size.width, nextImage.size.height); 
        UIButton* nextButton = [[UIButton alloc] initWithFrame:nextFrame]; 
        [nextButton setBackgroundImage:nextImage forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextList) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.currentList isLast]) {
            [nextButton setEnabled:NO];
        }

        [rightView addSubview:nextButton];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.headerView = nil;
    self.summaryView = nil;
    self.draggedCell = nil;
    self.alertWhenFinish = nil;
    self.alertDelegate = nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return VOCAVULARY_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 6 < [self.vocabulariesToRecite count] ? 6 : [self.vocabulariesToRecite count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int vocabularyIndex = indexPath.row;
    VSListVocabulary *listVocabulary = [vocabulariesToRecite objectAtIndex:vocabularyIndex];
    NSString *CellIdentifier = listVocabulary.vocabulary.spell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [VSVocabularyCell alloc];
        ((VSVocabularyCell *)cell).vocabulary = listVocabulary.vocabulary;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.highlighted = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    VSVocabularyCell* cell = (VSVocabularyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.curlUp) {
        VSVocabulary *selectedVocabulary = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:indexPath.row]).vocabulary;
        VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
        detailViewController.vocabulary = selectedVocabulary;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - Navigation Related
- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Gesture Related


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];

    BOOL dragged = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:indexPath.row]).dragged;
    if (dragged && translation.x < 0) {
        return NO;
    }
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self startDragging:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self doDrag:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self stopDragging:gestureRecognizer];
            break;
        default:
            break;
    }
}

- (void)startDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    self.touchPoint = point;
    if ([self.tableView pointInside:point withEvent:nil]) {
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
        VSVocabularyCell* cell = (VSVocabularyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if(cell != nil) {
            draggedCell = cell;
            draggedIndex = indexPath.row;
        }
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        if (!cell.curlUp && !draggedCell.curling && translation.x > 0 && !draggedCell.clearing) {
            [cell showClearView];
        }
    }
}

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    CGPoint translation = [gestureRecognizer translationInView:draggedCell];
    if (!draggedCell.curlUp && draggedCell.clearShow && !draggedCell.clearing) {
        [draggedCell moveClearView:point.x];
    }
    else {
        if (draggedCell.curlUp && !draggedCell.curling && !draggedCell.clearing && translation.x > 0) {
            [draggedCell dragSummary:point.x - 80];
        }
        else if (!draggedCell.curlUp && !draggedCell.curling && !draggedCell.clearing && translation.x < 0) {
            [draggedCell dragSummary:point.x];
        }
    }
}


- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (draggedCell != nil) {
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        
        if (draggedCell.clearShow && !draggedCell.curlUp && !draggedCell.clearing) {
            CGFloat margin = translation.x;
            BOOL clear = fabs(margin) > 120;
            [draggedCell clearVocabulry:clear];
        }
        else if (!draggedCell.curlUp && !draggedCell.clearing && translation.x < 0) {
            [draggedCell curlUp:point.x];
        }
        else if (draggedCell.curlUp && !draggedCell.clearing && translation.x > 0) {
            [draggedCell curlDown:point.x - 60];
        }
    }
}

#pragma mark - Notification

- (void)clearVocabulary:(NSNotification *)notification
{
    @synchronized(self) {
        int index = -1;
        VSVocabulary *vocabulary = [notification.userInfo objectForKey:@"vocabulary"];
        for (int i = 0 ; i < [self.vocabulariesToRecite count]; i++) {
            VSListVocabulary *listVocabulary = [self.vocabulariesToRecite objectAtIndex:i];
            if ([listVocabulary.vocabulary isEqual:vocabulary]) {
                index = i;
                break;
            }
        }
        VSListVocabulary *rememberedVocabulary = [vocabulariesToRecite objectAtIndex:index];
        [rememberedVocabulary remembered];
        [rememberedVocabulary.vocabulary remembered];
        if (![self.currentList isHistoryList]) {
            [self.listToday addVocabulary:rememberedVocabulary.vocabulary];
        }
        self.rememberCount++;
        [self upgradeProgress];
        [reviewPlan rememberVocabulary:rememberedVocabulary.vocabulary];
        [vocabulariesToRecite removeObjectAtIndex:index];
        [self updateVocabularyTable:index];
    }
}

- (void)upgradeProgress
{
    [self.headerView updateProgress:[self.currentList finishProgress]];
}

- (void)updateVocabularyTable:(int)index
{
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.vocabulariesToRecite count] > 5) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];    
    }
    [self.tableView endUpdates];
}

- (void)processAfterSwipe
{
    if ([self.vocabulariesToRecite count] == 0) {
        alertWhenFinish = nil;
        if ([self.currentList isHistoryList]) {
            alertWhenFinish = [[UIAlertView alloc] initWithTitle:@"" message:@"复习完毕" delegate:self cancelButtonTitle:@"嗯，好的" otherButtonTitles:nil,nil];
        }
        else {
            alertWhenFinish = [[UIAlertView alloc] initWithTitle:@"" message:@"当前List已经背诵完毕\n将进入下一个List的背诵" delegate:self cancelButtonTitle:@"嗯，好的" otherButtonTitles:nil,nil];
        }
        [alertWhenFinish setDelegate:self.alertDelegate];
        [alertWhenFinish show];
    }
}

- (void)nextList
{
    [VSUtils toNextList:self.currentList];
}

- (void)previousList
{
    [VSUtils toPreviousList:self.currentList];
}

- (void)restart
{
    [self.currentList clearVocabularyStatus];
    [VSUtils reloadCurrentList:self.currentList];
}

@end
