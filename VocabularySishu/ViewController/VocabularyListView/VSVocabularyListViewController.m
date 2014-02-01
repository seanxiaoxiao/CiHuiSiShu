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
#import "VSListRecord.h"
#import "VSListVocabularyRecord.h"
#import "VSVocabularyRecord.h"
#import "VSFloatPanelView.h"
#import "VSVocabularyPlayer.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocial.h"
#import "GADInterstitial.h"
#import "GADBannerView.h"

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
@synthesize days;
@synthesize pickerView;
@synthesize pickerAreaView;
@synthesize promptLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (![currentListRecord isHistoryList]) {
            self.listToday = [VSList createAndGetHistoryList];
        }
        [currentListRecord process];
        [currentListRecord resetFinishPlanDate];

        self.clearingCount = 0;

        self.vocabulariesToRecite = [self.currentListRecord vocabulariesToRecite];
        countOnStart = [self.vocabulariesToRecite count];
        self.cellStatus = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [self.vocabulariesToRecite count]; i++) {
            VSListVocabularyRecord *listVocabulary = [self.vocabulariesToRecite objectAtIndex:i];
            VSCellStatus *status = [[VSCellStatus alloc] init];
            status.curlUp = NO;
            [self.cellStatus setObject:status forKey:listVocabulary.vocabularyRecord.spell];
        }
        
        [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(backToMain)]];
        [self initRightButton];
        [self initNotifications];
        [self initBubbles];
        [self initGestures];

        days = [[NSArray alloc] initWithObjects:@"一天内完成", @"两天内完成", @"三天内完成", nil];
        [self initPickerView];
        
        if ([self.vocabulariesToRecite count] == 0) {
            [self toggleScoreBoard];
        }
    }
    return self;
}

- (void) initTitle
{
    UIView *headerLabels = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: 18.0f];
    label.shadowColor = [UIColor colorWithWhite:0 alpha:1];
    label.textAlignment = UITextAlignmentCenter;
    label.shadowOffset = CGSizeMake(0, -1);
    label.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1];
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 200, 18)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
    subLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    subLabel.textAlignment = UITextAlignmentCenter;
    subLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.7 alpha:1];
    subLabel.shadowOffset = CGSizeMake(0, -1);
    [headerLabels addSubview:label];
    [headerLabels addSubview:subLabel];
    self.navigationItem.titleView = headerLabels;
    
    if (currentList != nil) {
        label.text = [currentList repoCategory];
        subLabel.text = [currentList subName];
    }
    else {
        label.text = @"复习";
        subLabel.text = currentListRecord.name;
    }
}

- (void) initRightButton
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 90, 44.01)];
    rightView.backgroundColor = [UIColor clearColor];
    UIImage *scoreBoardImage = [VSUtils fetchImg:@"ScoreBoardButton"];
    CGRect scoreBoardFrame = CGRectMake(45, 0, scoreBoardImage.size.width, scoreBoardImage.size.height);
    UIButton *scoreBoardButton = [[UIButton alloc] initWithFrame:scoreBoardFrame];
    [scoreBoardButton setBackgroundImage:scoreBoardImage forState:UIControlStateNormal];
    [scoreBoardButton addTarget:self action:@selector(toggleScoreBoard) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:scoreBoardButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void) initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearVocabulary:) name:CLEAR_VOCABULRY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVocabulary:) name:PLAY_VOCABULARY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:RESTART_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextList) name:NEXT_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideScoreBoard) name:CLOSE_POPUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPickerArea) name:SHOW_PICKER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAfterEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share) name:SHARE_AFTER_FINISH object:nil];
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
    pickerAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 320, 204)];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 160)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.showsSelectionIndicator = YES;
    
    [pickerAreaView addSubview:pickerView];
    
    [self.view addSubview:pickerAreaView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 200, 21)];
    [promptLabel setBackgroundColor:[UIColor clearColor]];
    [promptLabel setTextColor:[UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1]];
    promptLabel.text = @"一天内背诵完列表中剩余单词";
    [promptLabel setTextAlignment:UITextAlignmentCenter];
    [promptLabel setFont:[UIFont systemFontOfSize:12]];
    UIBarButtonItem *prompt = [[UIBarButtonItem alloc] initWithCustomView:promptLabel];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *btnConfirm = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonSystemItemEdit target:self action:@selector(selectPlanFinishTime)];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(dismissPickerArea)];
    [toolBar setItems:[NSArray arrayWithObjects:btnCancel, prompt, btnConfirm, nil]];
    [pickerAreaView addSubview:toolBar];

}

- (void)selectPlanFinishTime
{
    [MobClick event:EVENT_SET_FINISH_PLAN];
    int daysToFinish = [self.pickerView selectedRowInComponent:0] + 1;
    [self.currentListRecord setPlanFinishDate:daysToFinish];
    [self.headerView startTimer];
    [self dismissPickerArea];
}

- (void)dismissPickerArea
{
    [UIView animateWithDuration:0.3 animations:^() {
        pickerAreaView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 320, 204);
    }];
}

- (void)showPickerArea
{
    if (pickerAreaView.frame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        [UIView animateWithDuration:0.3 animations:^() {
            pickerAreaView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 270, 320, 204);
        }];
    }
    else {
        [self dismissPickerArea];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTitle];
    
    self.headerView = [[VSFloatPanelView alloc] initWithFrame:CGRectMake(0, 0, 320, 80) withListRecord:self.currentListRecord ];
    self.headerView.wordsRemain = [vocabulariesToRecite count];
    [self.headerView updateWordsCount];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];

    UIImageView *containerBackgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"ListBG"]];
    [containerBackgroundImageView setFrame:self.view.frame];
    [self.view addSubview:containerBackgroundImageView];
    [self.view sendSubviewToBack:containerBackgroundImageView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 63)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    if (![VSUtils shouldHideAd]) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView.adUnitID = @"ca-app-pub-3320312069359444/9451773612";
        _bannerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50 - 64, 320, 50);
        _bannerView.rootViewController = self;
        [self.view addSubview:_bannerView];
        [self.view bringSubviewToFront:_bannerView];
        GADRequest *request = [GADRequest request];
        [_bannerView loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![VSUtils shouldHideAd]) {
        [self loadInterstitial];
    }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (cell.curlUp && !cell.curling && scoreBoardView == nil) {
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        self.promptLabel.text = @"一天内背诵完列表中剩余单词";
    }
    else if (row == 1) {
        self.promptLabel.text = @"两天内背诵完列表中剩余单词";
    }
    else {
        self.promptLabel.text = @"三天内背诵完列表中剩余单词";
    }
}

#pragma mark - Navigation Related
- (void)backToMain
{
    if (self.scoreBoardView == nil) {
        [self.navigationController popViewControllerAnimated:YES];
        [[iRate sharedInstance] logEvent:NO];
    }
}


#pragma mark - Gesture Related

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


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
            self.tableView.scrollEnabled = NO;
            break;
        case UIGestureRecognizerStateChanged:
            [self doDrag:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            self.tableView.scrollEnabled = YES;
            [self stopDragging:gestureRecognizer];
            break;
        case UIGestureRecognizerStateCancelled:
            self.tableView.scrollEnabled = YES;
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
        self.tableView.scrollEnabled = YES;
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        
        if (draggedCell.clearShow && !draggedCell.curlUp && !draggedCell.clearing) {
            CGFloat margin = translation.x;
            BOOL clear = fabs(margin) > 80;
            [draggedCell clearVocabulry:clear];
        }
        else if (!draggedCell.curlUp && !draggedCell.clearing && translation.x < 0) {
            [draggedCell curlUp:point.x];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showDetailBubble"] ) {
                detailBubble = [[TipsBubble alloc] initWithTips:@"更多信息，点击这里" width:145 popupFrom:tipsBubblePopupFromLowerRight];
                detailBubble.center = CGPointMake(155, draggedCell.frame.origin.y - 20);
                [self.view addSubview:detailBubble];
                [self.view bringSubviewToFront:detailBubble];
            }
        }
        else if (draggedCell.curlUp && !draggedCell.clearing) {
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
        [self.headerView clearWord];
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
    [self.tableView endUpdates];
}

- (void)processAfterSwipe
{
    if ([self.vocabulariesToRecite count] == 0) {
        [self.currentListRecord finish];
        [self toggleScoreBoard];
        [self showAdInstitial];
    }
    else if ((countOnStart - [self.vocabulariesToRecite count]) % 39 == 0) {
        [self showAdInstitial];
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

    CGRect modalRect = CGRectMake(50, [[UIScreen mainScreen] bounds].size.height / 2 - 125, 200, 170);
    scoreBoardView = [[VSScoreBoardView alloc] initWithFrame:modalRect finished:[vocabulariesToRecite count] == 0];
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

- (void)updateAfterEnterForeground
{
    [currentListRecord resetFinishPlanDate];
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


- (void)playVocabulary:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playAfterOpen"]) {
        VSVocabularyRecord *vocabularyRecord = [notification.userInfo objectForKey:@"vocabulary"];
        __autoreleasing VSVocabularyPlayer *player = [VSVocabularyPlayer getPlayer];
        [player play:[vocabularyRecord getVocabulary]];
    }
}

- (void)share
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.0%;0.0%-0.0%"];
    NSString *rememberRate = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self.currentListRecord rememberRate]]];
    NSString *appLink = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", [VSUtils getAppId]];
    NSString *shareText = [NSString stringWithFormat:@"我刚用 %@ 背诵完 %@ 这列单词，其中 %@ 的单词背得靠谱，你要不要来挑战一下我的记录啊 %@", [VSUtils getAppName], self.currentListRecord.name , rememberRate, appLink];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:[UMSocialData appKey]
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"icon512.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToDouban, UMShareToRenren, nil] delegate:nil];
}

- (void)showAdInstitial
{
    if (![VSUtils shouldHideAd]) {
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        }
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{

}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self reloadInterstitial];
}

- (void)reloadInterstitial
{
    self.interstitial = nil;
    [self loadInterstitial];
}

- (void)loadInterstitial
{
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = @"ca-app-pub-3320312069359444/7975040410";
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
}

@end
