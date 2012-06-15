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
@synthesize selectedVocabulary;
@synthesize listToday;
@synthesize meaningCellHeight;
@synthesize rememberView;
@synthesize forgetView;
@synthesize touchPoint;
@synthesize draggedCell;
@synthesize countInList;
@synthesize rememberCount;
@synthesize draggedIndex;
@synthesize currentList;
@synthesize alertWhenFinish;
@synthesize alertDelegate;

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
    NSLog(@"Init with new list");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.headerView = [[VSVocabularyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        self.tableView.tableHeaderView = headerView;
        if (![currentList isHistoryList]) {
            self.listToday = [VSList createAndGetHistoryList];
        }
        [currentList process];
        [self.headerView setProgress:[self.currentList finishProgress]];
        self.vocabulariesToRecite = [NSMutableArray arrayWithArray:[self.currentList vocabulariesToRecite]];
        self.countInList = [self.currentList.listVocabularies count];
        self.rememberCount = [self.currentList rememberedCount];
        self.title = self.currentList.name;
        
        __autoreleasing UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
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
    CGRect frame= CGRectMake(0, 0, image.size.width, image.size.height); 
    UIButton* backButton= [[UIButton alloc] initWithFrame:frame]; 
    [backButton setBackgroundImage:image forState:UIControlStateNormal]; 
    [backButton setTitle:@" 词汇私塾" forState:UIControlStateNormal]; 
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    backButton.titleLabel.font=[UIFont boldSystemFontOfSize:10];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.headerView = nil;
    self.rememberView = nil;
    self.forgetView = nil;
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
    if (indexPath.row == 1 && self.selectedVocabulary != nil) {
        return 416 - 59;
    }
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7 < [self.vocabulariesToRecite count] ? 7 : [self.vocabulariesToRecite count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1 && selectedVocabulary != nil) {
//        NSArray *meanings = [selectedVocabulary.meanings allObjects];
//        __autoreleasing VSMeaningCell *meaningCell = [[VSMeaningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VSMeaning"];
//        [meaningCell setMeaningContent:meanings];
//        return meaningCell;
//    }
    VSListVocabulary *listVocabulary = [vocabulariesToRecite objectAtIndex:indexPath.row];
    NSString *CellIdentifier = listVocabulary.vocabulary.spell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = listVocabulary.vocabulary.spell;
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"Selected");
    
    
//    UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell *cellOnTop = [[UITableViewCell alloc]initWithFrame:selectedCell.frame];
//    cellOnTop.center = selectedCell.center;
//    [cellOnTop.textLabel setTextAlignment:UITextAlignmentCenter];
//    cellOnTop.textLabel.text = selectedCell.textLabel.text;
//    cellOnTop.textLabel.backgroundColor = [UIColor clearColor];
//    cellOnTop.textLabel.textColor = [UIColor blackColor];
//    selectedVocabulary = [vocabulariesToRecite objectAtIndex:indexPath.row];
//    [self.tableView addSubview:cellOnTop];
//    [UIView animateWithDuration:0.5f 
//            delay:0.0f 
//            options:UIViewAnimationCurveLinear 
//            animations:^{
//                [cellOnTop setFrame:CGRectMake(0, 10, 320, 59)];
//            }
//            completion:^(BOOL finished) {
//                if (finished == YES) {
//                    firstCell.textLabel.text = cellOnTop.textLabel.text;
//                    [cellOnTop removeFromSuperview];
//                }
//            }
//         ];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
    VSListVocabulary *selected = [vocabulariesToRecite objectAtIndex:indexPath.row];
    detailViewController.vocabulary = selected.vocabulary;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Navigation Related
- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Gesture Related

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
            [self initAssistView];
            cell.highlighted = NO;
        }

    }
}

- (void)initAssistView
{
    CGPoint origin = draggedCell.frame.origin;
    NSLog(@"Dragged Cell %f", origin.y);
    
    origin.y -= 10;

    // get rid of old cell, if it wasn't disposed already
    if (rememberView != nil)
    {
        [rememberView removeFromSuperview];
        rememberView = nil;
    }
    if (forgetView != nil)
    {
        [forgetView removeFromSuperview];
        forgetView = nil;
    }
    CGRect rememberFrame = CGRectMake(320, 0, 50, draggedCell.frame.size.height);
    CGRect forgetFrame = CGRectMake(-50, 0, 50, draggedCell.frame.size.height);
    
    rememberView = [[UIView alloc] initWithFrame:rememberFrame];
    forgetView = [[UIView alloc] initWithFrame:forgetFrame];
    [rememberView setBackgroundColor:[UIColor greenColor]];
    rememberView.alpha = 0.8;
    [forgetView setBackgroundColor:[UIColor redColor]];
    forgetView.alpha = 0.8;
    [draggedCell addSubview:rememberView];
    [draggedCell addSubview:forgetView];
}

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:draggedCell];
    CGPoint cellCenter = draggedCell.center;
    CGFloat margin = translation.x;
    CGPoint newCenter = cellCenter;
    
    if (fabs(margin) > 50) {
        margin = margin / fabs(margin) * 50;
    }
    
    newCenter.x = 160 + margin;
    [draggedCell setCenter:newCenter];
}


- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint origin = draggedCell.frame.origin;
    CGPoint translation = [gestureRecognizer translationInView:draggedCell];
    CGFloat margin = translation.x;

    CGFloat targetX = 0;
    if (fabs(margin) > 100) {
        targetX = margin / fabs(margin) * 320;
    }

    if (draggedCell != nil) {
        [UIView animateWithDuration:0.5f 
                delay:0.0f 
                options:UIViewAnimationCurveLinear 
                animations:^{
                    [draggedCell setFrame:CGRectMake(targetX, origin.y, draggedCell.frame.size.width, draggedCell.frame.size.height)];
                }
                completion:^(BOOL finished) {
                    if (finished == YES) {
                        if (targetX != 0) {  //The cell had been swipped.
                            if (margin < 0) {
                                [self remember];
                                [self updateVocabularyTable:YES];
                            }
                            else {
                                [self forget];
                                [self updateVocabularyTable:NO];
                            }
                            [self processAfterSwipe];
                        }
                    }
                }
        ];
    }
}

- (void)forget
{
    VSListVocabulary *forgotVocabulary = [vocabulariesToRecite objectAtIndex:draggedIndex];
    [forgotVocabulary forgot];
    [forgotVocabulary.vocabulary forgot];
    [vocabulariesToRecite removeObjectAtIndex:draggedIndex];
    [vocabulariesToRecite addObject:forgotVocabulary];
}

- (void)remember
{
    NSLog(@"Remembered");
    VSListVocabulary *rememberedVocabulary = [vocabulariesToRecite objectAtIndex:draggedIndex];
    [rememberedVocabulary remembered];
    [rememberedVocabulary.vocabulary remembered];
    if (![self.currentList isHistoryList]) {
        [self.listToday addVocabulary:rememberedVocabulary.vocabulary];
    }
    self.rememberCount++;
    [self upgradeProgress];
    [vocabulariesToRecite removeObjectAtIndex:draggedIndex];
}

- (void)upgradeProgress
{
    CGFloat progress = (CGFloat)self.rememberCount / (CGFloat)self.countInList;
    [self.headerView setProgress:progress];
}

- (void)updateVocabularyTable:(BOOL)remember
{
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (remember && [self.vocabulariesToRecite count] > 6) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];    
    }
    else if (!remember) {
        int newIndex = [self.vocabulariesToRecite count] > 6 ? 6 : [self.vocabulariesToRecite count] - 1;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
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


@end
