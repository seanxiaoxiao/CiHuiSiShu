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
@synthesize meaningCellHeight;
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
@synthesize clearView;

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
        self.reviewPlan = [VSReviewPlan getPlan];
        self.headerView = [[VSVocabularyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        self.tableView.tableHeaderView = headerView;
        if (![currentList isHistoryList]) {
            self.listToday = [VSList createAndGetHistoryList];
        }
        [currentList process];
        self.vocabulariesToRecite = [NSMutableArray arrayWithArray:[self.currentList vocabulariesToRecite]];
        self.countInList = [self.currentList.listVocabularies count];
        self.rememberCount = [self.currentList rememberedCount];
        self.selectedIndex = -1;
        self.title = self.currentList.name;

        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ListBG"]];
        [backgroundImageView setFrame:self.tableView.frame]; 
        
        self.tableView.backgroundView = backgroundImageView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postLoadingMeaningView:) name:FINISH_LOADING_MEANING_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailView) name:SHOW_DETAIL_VIEW object:nil];

        __autoreleasing UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];
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
    self.clearView = nil;
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
    return 59;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = listVocabulary.vocabulary.spell;
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.alpha = 0.7f;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:18];
    cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    cell.textLabel.shadowColor = [UIColor whiteColor];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellBG"]];
    cellBackgroundView.center = cell.center;
    cell.backgroundView = cellBackgroundView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted = NO;

    CGRect summaryFrame = CGRectMake(320, 0, 320, cell.frame.size.height);    
    summaryView = [VSSummaryView alloc];
    summaryView.vocabulary = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:indexPath.row]).vocabulary;
    summaryView = [summaryView initWithFrame:summaryFrame];
    
    [cell addSubview:summaryView];
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
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
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
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
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
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(cell != nil)
        {
            draggedCell = cell;
            draggedIndex = indexPath.row;
        }
        BOOL dragged = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:draggedIndex]).dragged;
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        if (!dragged && translation.x > 0) {
            if (clearView != nil) {
                [clearView removeFromSuperview];
                clearView = nil;
            }
            UIImage *clearImage = [VSUtils fetchImg:@"CellClear"];
            clearView = [[UIImageView alloc] initWithImage:clearImage];
            clearView.hidden = YES;
            [draggedCell.textLabel addSubview:clearView];            
            clearView.clipsToBounds = YES;
        }
    }
}

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:draggedCell];
    CGPoint cellCenter = draggedCell.center;
    CGFloat margin = translation.x;
    CGPoint newCenter = cellCenter;
        
    newCenter.x = 160 + margin;
    BOOL dragged = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:draggedIndex]).dragged;
    if (!dragged && clearView != nil) {
        CGPoint clearCenter = clearView.center;
        clearCenter.x = margin - 100;
        clearView.hidden = NO;
        [clearView setCenter:clearCenter];
    }
    else {
        if (dragged) {
            newCenter.x -= 320;
        }
        if (fabs(newCenter.x) > 160) {
            newCenter.x = newCenter.x / fabs(newCenter.x) * 160;
        }
        [draggedCell setCenter:newCenter];
    }
}


- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (draggedCell != nil) {
        CGPoint origin = draggedCell.frame.origin;
        CGPoint translation = [gestureRecognizer translationInView:draggedCell];
        CGFloat margin = translation.x;
        CGFloat targetX = 0;

        BOOL dragged = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:draggedIndex]).dragged;
        if (!dragged && fabs(margin) > 120) {
            targetX = margin / fabs(margin) * 320;
        }
        
        if (clearView != nil && !dragged && translation.x > 0) {
            [UIView animateWithDuration:0.5f 
                delay:0.0f 
                options:UIViewAnimationCurveLinear 
                animations:^{
                    CGPoint center = clearView.center;
                    center.x = draggedCell.center.x;
                    [clearView setCenter:center];
                }
                completion:^(BOOL finished) {
                    if (finished == YES) {
                        [self clearVocabulary];
                        [self updateVocabularyTable];
                    }
                }
            ];
        }
        else {
            [UIView animateWithDuration:0.5f 
                delay:0.0f 
                options:UIViewAnimationCurveLinear 
                animations:^{
                    [draggedCell setFrame:CGRectMake(targetX, origin.y, draggedCell.frame.size.width, draggedCell.frame.size.height)];
                }
                completion:^(BOOL finished) {
                    if (finished == YES) {
                        CGFloat cellCenterX = draggedCell.center.x;
                        if (dragged && cellCenterX == 160) {
                            ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:draggedIndex]).dragged = NO;
                        }
                        else if (!dragged && cellCenterX == -160) {
                            ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:draggedIndex]).dragged = YES;
                        }
                    }
                }
            ];
        }
    }
}

#pragma mark - Notification

- (void)postLoadingMeaningView:(id)object
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    NSIndexPath *meaningCellIndexPath = [NSIndexPath indexPathForRow:(selectedIndex + 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:meaningCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)showDetailView
{
    VSVocabulary *selectedVocabulary = ((VSListVocabulary *)[self.vocabulariesToRecite objectAtIndex:selectedIndex]).vocabulary;
    VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
    detailViewController.vocabulary = selectedVocabulary;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)clearVocabulary
{
    VSListVocabulary *rememberedVocabulary = [vocabulariesToRecite objectAtIndex:draggedIndex];
    [rememberedVocabulary remembered];
    [rememberedVocabulary.vocabulary remembered];
    if (![self.currentList isHistoryList]) {
        [self.listToday addVocabulary:rememberedVocabulary.vocabulary];
    }
    self.rememberCount++;
    [self upgradeProgress];
    [reviewPlan rememberVocabulary:rememberedVocabulary.vocabulary];
    [vocabulariesToRecite removeObjectAtIndex:draggedIndex];
}

- (void)upgradeProgress
{
    CGFloat progress = (CGFloat)self.rememberCount / (CGFloat)self.countInList;
}

- (void)updateVocabularyTable
{
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
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


@end
