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
@synthesize currentList;
@synthesize alertWhenFinish;
@synthesize alertDelegate;
@synthesize scoreBoardView;
@synthesize blockView;

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
            if (![currentList isHistoryList]) {
                self.listToday = [VSList createAndGetHistoryList];
            }
            [currentList process];
            self.countInList = [self.currentList.listVocabularies count];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:RESTART_LIST object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextList) name:NEXT_LIST object:nil];
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
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 43, 44.01)];
    rightView.backgroundColor = [UIColor clearColor];
    UIImage *scoreBoardImage = [VSUtils fetchImg:@"ScoreBoardButton"];
    CGRect scoreBoardFrame = CGRectMake(0, 0, scoreBoardImage.size.width, scoreBoardImage.size.height);
    UIButton *scoreBoardButton = [[UIButton alloc] initWithFrame:scoreBoardFrame];
    [scoreBoardButton setBackgroundImage:scoreBoardImage forState:UIControlStateNormal];
    [scoreBoardButton addTarget:self action:@selector(showHideScoreBoard) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:scoreBoardButton];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
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
    self.blockView = nil;
    self.scoreBoardView = nil;
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
    NSString *CellIdentifier = @"VocabularyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [VSVocabularyCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.highlighted = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [((VSVocabularyCell *)cell) initWithVocabulary:listVocabulary.vocabulary];
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
    if (cell.curlUp && scoreBoardView == nil) {
        VSVocabulary *selectedVocabulary = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:indexPath.row]).vocabulary;
        VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
        detailViewController.vocabulary = selectedVocabulary;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


#pragma mark - Navigation Related
- (void)backToMain
{
    if (self.scoreBoardView == nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Gesture Related

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (scoreBoardView != nil) {
        return NO;
    }
    UIView *cell = [gestureRecognizer view];
    CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    VSVocabularyCell* touchedCell = (VSVocabularyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (touchedCell.curlUp && translation.x < 0) {
        return NO;
    }
    if (touchedCell == nil && draggedCell != nil) {
        return NO;
    }
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}


- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    gestureRecognizer.cancelsTouchesInView = NO;
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
        case UIGestureRecognizerStateCancelled:
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
        [rememberedVocabulary.vocabulary remembered];
        [rememberedVocabulary remembered];
        if (![self.currentList isHistoryList]) {
            [self.listToday addVocabulary:rememberedVocabulary.vocabulary];
        }
        self.rememberCount++;
        [self.headerView updateProgress:[self.currentList finishProgress]];
        [vocabulariesToRecite removeObjectAtIndex:index];
        [self updateVocabularyTable:index];
        [self processAfterSwipe];
    }
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
        [self.currentList finish];
        if ([self.currentList isHistoryList]) {
            alertWhenFinish = [[UIAlertView alloc] initWithTitle:@"" message:@"复习完毕" delegate:self cancelButtonTitle:@"嗯，好的" otherButtonTitles:nil, nil];
            [alertWhenFinish setDelegate:self.alertDelegate];
            [alertWhenFinish show];
        }
        else {
            [self showHideScoreBoard];
        }
    }
}

- (void)showHideScoreBoard
{
    if (scoreBoardView == nil) {
        CGRect modalRect = CGRectMake(50, 105, 200, 210);
        scoreBoardView = [[VSScoreBoardView alloc] initWithFrame:modalRect];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.2f];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[scoreBoardView layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        [self.view addSubview:scoreBoardView];
        [scoreBoardView performSelector:@selector(initWithList:) withObject:self.currentList afterDelay:0.5f];
        UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton addTarget:self action:@selector(hideScoreBoard) forControlEvents:UIControlEventTouchUpInside];
        [exitButton setTitle:@"" forState:UIControlStateNormal];
        exitButton.frame = self.view.frame;
        self.blockView = [[UIView alloc] initWithFrame:self.view.frame];
        self.blockView.backgroundColor = [UIColor blackColor];
        self.blockView.alpha = 0.1;
        [self.view addSubview:self.blockView];
        [self.view addSubview:exitButton];
        [self.view bringSubviewToFront:scoreBoardView];
    }
    else {
        [self hideScoreBoard];
    }
}

- (void)hideScoreBoard
{
    [UIView beginAnimations:@"removeWithEffect" context:nil];
    [UIView setAnimationDuration:0.2f];
    scoreBoardView.alpha = 0.0f;
    [UIView commitAnimations];
    [scoreBoardView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
    scoreBoardView = nil;
    [self.blockView removeFromSuperview];
    self.blockView = nil;
}

- (void)restart
{
    [self performSelector:@selector(doRestart) withObject:nil afterDelay:0.2f];
}

- (void)doRestart
{
    [self.currentList clearVocabularyStatus];
    [VSUtils reloadCurrentList:self.currentList];
}

- (void)nextList
{
    [self performSelector:@selector(doNextList) withObject:nil afterDelay:0.2f];
}

- (void)doNextList
{
    [VSUtils toNextList:self.currentList];
}



@end
