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
#import "iRate.h"
#import "VSCellStatus.h"
#import "FDCurlViewControl.h"
#import "VSListRecord.h"
#import "VSListVocabularyRecord.h"
#import "VSVocabularyRecord.h"
#import "VSRememberedList.h"

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
@synthesize currentListRecord;
@synthesize scoreBoardView;
@synthesize blockView;
@synthesize exitButton;
@synthesize vocabularyActionBubble;
@synthesize detailBubble;
@synthesize tableView;
@synthesize cellStatus;
@synthesize containerView;
@synthesize curlButton;
@synthesize planFinishButton;
@synthesize days;
@synthesize pickerView;
@synthesize planFinishLabel;
@synthesize revertButton;
@synthesize rememberedList;
@synthesize inRevert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (![currentListRecord isHistoryList]) {
            self.listToday = [VSList createAndGetHistoryList];
        }
        [currentListRecord process];
        [currentListRecord resetFinishPlanDate];

        self.title = [self getTitle];
        self.clearingCount = 0;
        
        self.vocabulariesToRecite = [self.currentListRecord vocabulariesToRecite];;
        self.cellStatus = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [self.vocabulariesToRecite count]; i++) {
            VSListVocabularyRecord *listVocabulary = [self.vocabulariesToRecite objectAtIndex:i];
            VSCellStatus *status = [[VSCellStatus alloc] init];
            status.curlUp = NO;
            [self.cellStatus setObject:status forKey:listVocabulary.vocabularyRecord.spell];
        }
        self.rememberedList = [[VSRememberedList alloc] init];
        
        [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(backToMain)]];
        [self initRightButton];
        [self initNotifications];
        [self initBubbles];
        [self initGestures];

        [self initCurlUp];
        [self initRevertButton];
        if (![currentListRecord isHistoryList]) {
            days = [[NSArray alloc] initWithObjects:@"1天内完成", @"2天内完成", @"3天内完成", nil];
            [self initPlanFinishButton];
            [self initPickerView];
            [self drawPlanFinishLabel];
        }

        if ([self.vocabulariesToRecite count] == 0) {
            [self toggleScoreBoard];
        }
        
    }
    return self;
}

- (void) initRightButton
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 43, 44.01)];
    rightView.backgroundColor = [UIColor clearColor];
    UIImage *scoreBoardImage = [VSUtils fetchImg:@"ScoreBoardButton"];
    CGRect scoreBoardFrame = CGRectMake(0, 0, scoreBoardImage.size.width, scoreBoardImage.size.height);
    UIButton *scoreBoardButton = [[UIButton alloc] initWithFrame:scoreBoardFrame];
    [scoreBoardButton setBackgroundImage:scoreBoardImage forState:UIControlStateNormal];
    [scoreBoardButton addTarget:self action:@selector(toggleScoreBoard) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:scoreBoardButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void) initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearVocabulary:) name:CLEAR_VOCABULRY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:RESTART_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextList) name:NEXT_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideScoreBoard) name:CLOSE_POPUP object:nil];
}

- (void) initBubbles
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showActionBubble"] ) {
        vocabularyActionBubble = [[TipsBubble alloc] initWithTips:@"记住单词，向右划掉。\n忘记单词，左划查看意思" width:155 popupFrom:tipsBubblePopupFromLowerCenter];
        vocabularyActionBubble.center = CGPointMake(160, 35);
        [self.view addSubview:vocabularyActionBubble];
    }
}

- (void) initGestures
{
    __autoreleasing UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}

- (void) initPickerView
{
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 296, 320, 120)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.hidden = YES;
    
    [self.view addSubview:pickerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self updateRevertButton];
    
    self.headerView = [[VSVocabularyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.headerView setWordRemains:[vocabulariesToRecite count]];
    [self.headerView updateProgress:[self.currentListRecord finishProgress]];
    [self.containerView addSubview:self.headerView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    UIImageView *containerBackgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
    [containerBackgroundImageView setFrame:self.containerView.frame];
    [self.containerView addSubview:containerBackgroundImageView];
    [self.containerView sendSubviewToBack:containerBackgroundImageView];
}

- (void) initCurlUp
{
    curlButton = [[FDCurlViewControl alloc] initWithFrame:CGRectMake(290.0f, 396.0f, 30.0f, 20.0f)];
	[curlButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[curlButton setHidesWhenAnimating:NO];
	[curlButton setTargetView:self.containerView];
    curlButton.delegate = self;
    [self.containerView addSubview:curlButton];
    
}

- (void) initPlanFinishButton
{
    UIImage *normalButtonImage = [VSUtils fetchImg:@"ButtonBT"];
    UIImage *highlightButtonImage = [VSUtils fetchImg:@"ButtonBTHighLighted"];
 
    [self.planFinishButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
    [self.planFinishButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
    [self.planFinishButton setTitle:@"设置完成背诵时间" forState:UIControlStateNormal];
    
    [self.planFinishButton addTarget:self action:@selector(touchFinishPlan) forControlEvents:UIControlEventTouchUpInside];
    [self.planFinishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.planFinishButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.planFinishButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.planFinishButton.titleLabel.shadowColor = [UIColor blackColor];
}


- (void) initRevertButton
{
    UIImage *normalButtonImage = [VSUtils fetchImg:@"ButtonBT"];
    UIImage *highlightButtonImage = [VSUtils fetchImg:@"ButtonBTHighLighted"];
    
    [self.revertButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
    [self.revertButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
    [self.revertButton setTitle:@"反悔上一个单词" forState:UIControlStateNormal];
    [self.revertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.revertButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.revertButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.revertButton.titleLabel.shadowColor = [UIColor blackColor];
}

- (void) drawPlanFinishLabel
{
    if (self.currentListRecord.finishPlanDate != nil) {
        self.planFinishLabel.hidden = NO;
        self.planFinishButton.hidden = YES;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:self.currentListRecord.finishPlanDate];
        int month = [components month];
        int day = [components day];
        self.planFinishLabel.text = [NSString stringWithFormat:@"计划背诵完成时间为%d月%d日\n加油吧同学！", month, day];
    }
    else {
        [self.planFinishButton setTitle:@"设置完成背诵时间" forState:UIControlStateNormal];
        self.planFinishButton.hidden = NO;
        self.planFinishLabel.hidden = YES;
    }
}

- (void) touchFinishPlan
{
    if (self.pickerView.hidden) {
        self.pickerView.hidden = NO;
        [self.planFinishButton setTitle:@"就这个时间" forState:UIControlStateNormal];
    }
    else {
        self.pickerView.hidden = YES;
        [MobClick event:EVENT_SET_FINISH_PLAN];
        int daysToFinish = [self.pickerView selectedRowInComponent:0] + 1;
        [self.currentListRecord setPlanFinishDate:daysToFinish];
        [self drawPlanFinishLabel];
        [self.planFinishButton setTitle:@"设置完成背诵时间" forState:UIControlStateNormal];
    }
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
    self.planFinishButton = nil;
    self.planFinishLabel = nil;
    self.revertButton = nil;
    self.rememberedList = nil;
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
    VSListVocabularyRecord *listVocabularyRecord = [vocabulariesToRecite objectAtIndex:vocabularyIndex];
    NSString *CellIdentifier = @"VocabularyCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [VSVocabularyCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.highlighted = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ((VSVocabularyCell *)cell).statusDictionary = cellStatus;
    }
    [((VSVocabularyCell *)cell) initWithVocabulary:listVocabularyRecord.vocabularyRecord];
    [((VSVocabularyCell *)cell) resetStatus];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         cell.alpha = 1.0f;
                     }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissDetailBubble];
    VSVocabularyCell* cell = (VSVocabularyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.curlUp && scoreBoardView == nil) {
        [MobClick event:EVENT_ENTER_DETAIL];
        VSVocabulary *selectedVocabulary = [((VSListVocabularyRecord *)[self.vocabulariesToRecite objectAtIndex:indexPath.row]).vocabularyRecord getVocabulary];
        VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
        detailViewController.vocabulary = selectedVocabulary;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - Picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [days count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{    
    return [days objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.text = [days objectAtIndex:row];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    return label;
}

#pragma mark - Navigation Related
- (void)backToMain
{
    if (self.scoreBoardView == nil) {
        self.curlButton.delegate = nil;
        [self.navigationController popViewControllerAnimated:YES];
#ifdef TRIAL
        [[iRate sharedInstance] logEvent:NO];
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
            [cell initBeforeCurlup];
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
            if (!clear) {
                [self resetScroll];
            }
        }
        else if (!draggedCell.curlUp && !draggedCell.clearing && translation.x < 0) {
            [draggedCell curlUp:point.x];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showDetailBubble"] ) {
                detailBubble = [[TipsBubble alloc] initWithTips:@"更多信息，点击这里" width:145 popupFrom:tipsBubblePopupFromLowerRight];
                detailBubble.center = CGPointMake(155, draggedCell.frame.origin.y + 40);
                [self.view addSubview:detailBubble];
                [self.view bringSubviewToFront:detailBubble];
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
        VSVocabularyRecord *vocabularyRecord = [notification.userInfo objectForKey:@"vocabulary"];
        for (int i = 0; i < [self.vocabulariesToRecite count]; i++) {
            VSListVocabularyRecord *listVocabulary = [self.vocabulariesToRecite objectAtIndex:i];
            if ([listVocabulary.vocabularyRecord isEqual:vocabularyRecord]) {
                index = i;
                break;
            }
        }
        VSListVocabularyRecord *rememberedVocabulary = [vocabulariesToRecite objectAtIndex:index];
        [rememberedVocabulary.vocabularyRecord remembered];
        [rememberedVocabulary remembered];
        if (![self.currentListRecord isHistoryList]) {
            [self.listToday addVocabulary:rememberedVocabulary.vocabularyRecord];
        }
        [self.rememberedList addNewToken:index withRecord:rememberedVocabulary];
        [self updateRevertButton];
        [self.headerView updateProgress:[self.currentListRecord finishProgress]];
        [self.headerView decrWordRemain];
        [vocabulariesToRecite removeObjectAtIndex:index];
        [self updateVocabularyTable:index];
        [self resetScroll];
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

- (void)updateRevertButton
{
    if ([self.rememberedList isEmpty]) {
        self.revertButton.hidden = YES;
    }
    else {
        self.revertButton.hidden = NO;
    }
    inRevert = NO;
}

- (void)processAfterSwipe
{
    if ([self.vocabulariesToRecite count] == 0) {
        [self.currentListRecord finish];
        [self toggleScoreBoard];
#ifndef TRIAL
        [[iRate sharedInstance] logEvent:NO];
#endif
    }
}

- (void)resetScroll
{
    self.clearingCount--;
    if (self.clearingCount == 0) {
        self.tableView.scrollEnabled = YES;
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
    [scoreBoardView performSelector:@selector(initWithList:) withObject:self.currentListRecord afterDelay:0.5f];
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
    [self.currentListRecord clearVocabularyStatus];
    [VSUtils reloadCurrentList:self.currentListRecord];
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

- (NSString *)getTitle
{
    if (currentList != nil) {
        return [currentList titleName];
    }
    else {
        return currentListRecord.name;
    }
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

- (IBAction)revertToken:(id)sender
{
    [MobClick event:EVENT_REVERT_TOKEN];
    inRevert = YES;
    [curlButton curlViewDown];
}

- (void)curlViewControlWillCurlViewDown:(FDCurlViewControl *)control
{
    self.pickerView.hidden = YES;
}

- (void)curlViewControlDidCurlViewDown:(FDCurlViewControl *)control
{
    [self.planFinishButton setTitle:@"设置完成背诵时间" forState:UIControlStateNormal];
    if (inRevert) {
        VSRememberedToken *token = [self.rememberedList popToken];
        [token.record revert];
        [self.vocabulariesToRecite insertObject:token.record atIndex:token.index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:token.index inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self.headerView setWordRemains:[vocabulariesToRecite count]];
        [self.headerView updateProgress:[self.currentListRecord finishProgress]];
        [self updateRevertButton];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:token.index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        inRevert = NO;
    }
}

@end
