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
#import "MobClick.h"
#import "VSUIUtils.h"
#import "Appirater.h"
#import "VSCellStatus.h"
#import "FDCurlViewControl.h"

@interface VSVocabularyListViewController ()

@end

@implementation VSVocabularyListViewController

@synthesize vocabulariesToRecite;
@synthesize headerView;
@synthesize listToday;
@synthesize summaryView;
@synthesize touchPoint;
@synthesize draggedCell;
@synthesize currentList;
@synthesize scoreBoardView;
@synthesize blockView;
@synthesize exitButton;
@synthesize vocabularyActionBubble;
@synthesize detailBubble;
@synthesize tableView;
@synthesize cellStatus;
@synthesize containerView;
@synthesize curlButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (![currentList isHistoryList]) {
            self.listToday = [VSList createAndGetHistoryList];
        }
        [currentList process];

        self.title = [self.currentList titleName];
        self.clearingCount = 0;
        
        NSLog(@"%@", self.currentList.finishPlanDate);

        NSArray *vocabularies = [self.currentList vocabulariesToRecite];
        self.vocabulariesToRecite = [NSMutableArray arrayWithArray:vocabularies];
        self.cellStatus = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [self.vocabulariesToRecite count]; i++) {
            VSListVocabulary *listVocabulary = [self.vocabulariesToRecite objectAtIndex:i];
            VSCellStatus *status = [[VSCellStatus alloc] init];
            status.curlUp = NO;
            [self.cellStatus setObject:status forKey:listVocabulary.vocabulary.spell];
        }

        [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(backToMain)]];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 43, 44.01)];
        rightView.backgroundColor = [UIColor clearColor];
        UIImage *scoreBoardImage = [VSUtils fetchImg:@"ScoreBoardButton"];
        CGRect scoreBoardFrame = CGRectMake(0, 0, scoreBoardImage.size.width, scoreBoardImage.size.height);
        UIButton *scoreBoardButton = [[UIButton alloc] initWithFrame:scoreBoardFrame];
        [scoreBoardButton setBackgroundImage:scoreBoardImage forState:UIControlStateNormal];
        [scoreBoardButton addTarget:self action:@selector(toggleScoreBoard) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:scoreBoardButton];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearVocabulary:) name:CLEAR_VOCABULRY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:RESTART_LIST object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextList) name:NEXT_LIST object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideScoreBoard) name:CLOSE_POPUP object:nil];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showActionBubble"] ) {
            vocabularyActionBubble = [[TipsBubble alloc] initWithTips:@"记住单词，向右划掉。\n忘记单词，左划查看意思" width:155 popupFrom:tipsBubblePopupFromLowerCenter];
            vocabularyActionBubble.center = CGPointMake(160, 35);
            [self.view addSubview:vocabularyActionBubble];
        }
        __autoreleasing UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];

        if ([self.vocabulariesToRecite count] == 0) {
            [self toggleScoreBoard];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerView = [[VSVocabularyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.headerView setWordRemains:[vocabulariesToRecite count]];
    [self.headerView updateProgress:[self.currentList finishProgress]];
    [self.containerView addSubview:self.headerView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    UIImageView *containerBackgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [containerBackgroundImageView setFrame:self.containerView.frame];
    [self.containerView addSubview:containerBackgroundImageView];
    [self.containerView sendSubviewToBack:containerBackgroundImageView];
    
    [self initCurlUp];
}

- (void) initCurlUp
{
    curlButton = [[FDCurlViewControl alloc] initWithFrame:CGRectMake(290.0f, 396.0f, 30.0f, 20.0f)];
	[curlButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[curlButton setHidesWhenAnimating:NO];
	[curlButton setTargetView:self.containerView];
    [self.containerView addSubview:curlButton];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	for (UITouch *touch in touches) {
		CGPoint point = [touch locationInView:self.view];
		if (point.y < round(CGRectGetHeight(self.view.frame)/2.0f)) {
			[curlButton curlViewDown];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.headerView = nil;
    self.summaryView = nil;
    self.draggedCell = nil;
    self.blockView = nil;
    self.scoreBoardView = nil;
    self.exitButton = nil;
    self.containerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return VOCAVULARY_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vocabulariesToRecite count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int vocabularyIndex = indexPath.row;
    VSListVocabulary *listVocabulary = [vocabulariesToRecite objectAtIndex:vocabularyIndex];
    NSString *CellIdentifier = @"VocabularyCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [VSVocabularyCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.highlighted = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ((VSVocabularyCell *)cell).statusDictionary = cellStatus;
    }
    [((VSVocabularyCell *)cell) initWithVocabulary:listVocabulary.vocabulary];
    [((VSVocabularyCell *)cell) resetStatus];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissDetailBubble];
    VSVocabularyCell* cell = (VSVocabularyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.curlUp && scoreBoardView == nil) {
        [MobClick event:EVENT_ENTER_DETAIL];
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
#ifdef TRIAL
        [Appirater userDidSignificantEvent:YES];
#endif
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
    //Horizontal Gesture.
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
            self.clearingCount++;
            self.tableView.scrollEnabled = NO;
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
        [self dismissActionBubble];
        [self dismissDetailBubble];
        
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        
        if (draggedCell.clearShow && !draggedCell.curlUp && !draggedCell.clearing) {
            CGFloat margin = translation.x;
            BOOL clear = fabs(margin) > 120;
            [draggedCell clearVocabulry:clear];
        }
        else if (!draggedCell.curlUp && !draggedCell.clearing && translation.x < 0) {
            [draggedCell curlUp:point.x];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showDetailBubble"] ) {
                detailBubble = [[TipsBubble alloc] initWithTips:@"更多信息，点击这里" width:145 popupFrom:tipsBubblePopupFromLowerRight];
                detailBubble.center = CGPointMake(155, draggedCell.frame.origin.y - 20);
                [self.view addSubview:detailBubble];
            }
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
        [self.headerView updateProgress:[self.currentList finishProgress]];
        [self.headerView decrWordRemain];
        [vocabulariesToRecite removeObjectAtIndex:index];
        [self updateVocabularyTable:index];
        self.clearingCount--;
        if (self.clearingCount == 0) {
            self.tableView.scrollEnabled = YES;
        }
        [self processAfterSwipe];
    }
}

- (void)updateVocabularyTable:(int)index
{
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)processAfterSwipe
{
    if ([self.vocabulariesToRecite count] == 0) {
        [self.currentList finish];
        [self toggleScoreBoard];
#ifndef TRIAL
        [Appirater userDidSignificantEvent:YES];
#endif
    }
}

- (void)toggleScoreBoard
{
    if (scoreBoardView == nil) {
        [self showScroeBoard];
    }
    else {
        [self hideScoreBoard];
    }
}

- (void)showScroeBoard
{
    [MobClick event:EVENT_SHOW_SCORE];

    CGRect modalRect = CGRectMake(50, 105, 200, 170);
    scoreBoardView = [[VSScoreBoardView alloc] initWithFrame:modalRect];
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.2f];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[scoreBoardView layer] addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:scoreBoardView];
    [scoreBoardView performSelector:@selector(initWithList:) withObject:self.currentList afterDelay:0.5f];
    exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton addTarget:self action:@selector(hideScoreBoard) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitle:@"" forState:UIControlStateNormal];
    exitButton.frame = self.view.frame;
    self.blockView = [[UIView alloc] initWithFrame:self.view.frame];
    self.blockView.backgroundColor = [UIColor blackColor];
    self.blockView.alpha = 0.1;
    [self.view addSubview:self.blockView];
    [self.view addSubview:exitButton];
    [self.view bringSubviewToFront:scoreBoardView];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
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
    [self.exitButton removeFromSuperview];
    self.exitButton = nil;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)restart
{
    [self performSelector:@selector(doRestart) withObject:nil afterDelay:0.2f];
}

- (void)doRestart
{
    [MobClick event:EVENT_RETRY];
    [self.currentList clearVocabularyStatus];
    [VSUtils reloadCurrentList:self.currentList];
}

- (void)nextList
{
    [self performSelector:@selector(doNextList) withObject:nil afterDelay:0.2f];
}

- (void)doNextList
{
    [MobClick event:EVENT_NEXT_LIST];
    [VSUtils toNextList:self.currentList];
}

#pragma mark - Bubble Dismiss

- (void)dismissActionBubble
{
    if (vocabularyActionBubble != nil) {
        [vocabularyActionBubble removeFromSuperview];
        vocabularyActionBubble = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showActionBubble"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)dismissDetailBubble
{
    if (detailBubble != nil) {
        [detailBubble removeFromSuperview];
        detailBubble = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showDetailBubble"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)curlUp:(id)sender
{
    VSVocabularyViewController * myModalVC = [[VSVocabularyViewController alloc] init];
    [myModalVC setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    
    [self presentModalViewController:myModalVC animated:YES];
}


@end
