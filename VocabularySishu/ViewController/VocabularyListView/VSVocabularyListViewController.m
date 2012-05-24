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
#import "Context.h"
#import "List.h"
#import "ListVocabulary.h"
#import "Meaning.h"

@interface VSVocabularyListViewController ()

@end

@implementation VSVocabularyListViewController

@synthesize vocabulariesToRecite;
@synthesize finishProgress;
@synthesize selectedVocabulary;
@synthesize meaningCellHeight;
@synthesize draggedView;

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
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"List" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSString *predicateContent = [NSString stringWithFormat:@"(name=='GRE顺序List1')"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
        [request setPredicate:predicate];
        NSError *error = nil;
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        List *list = [array objectAtIndex:0];
        self.vocabulariesToRecite = [NSMutableArray arrayWithArray:[list.listVocabularies allObjects]];
        self.title = list.name;
        
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
    self.finishProgress = nil;
    self.draggedView = nil;
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
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.row == 1 && selectedVocabulary != nil) {
        NSArray *meanings = [selectedVocabulary.meanings allObjects];
        __autoreleasing VSMeaningCell *meaningCell = [[VSMeaningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Meaning"];
        [meaningCell setMeaningContent:meanings];
        return meaningCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    ListVocabulary *listVocabulary = [vocabulariesToRecite objectAtIndex:indexPath.row];
    cell.textLabel.text = listVocabulary.vocabulary.spell;
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.backgroundView.backgroundColor = [UIColor blueColor];
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
    if (selectedVocabulary == nil) {
        ListVocabulary *listVocabulary = [vocabulariesToRecite objectAtIndex:indexPath.row];
        self.selectedVocabulary = listVocabulary.vocabulary;
        [self.vocabulariesToRecite insertObject:self.selectedVocabulary atIndex:1];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else {
        self.selectedVocabulary = nil;
        [self.vocabulariesToRecite removeObjectAtIndex:1];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    VSVocabularyViewController *detailViewController = [[VSVocabularyViewController alloc] initWithNibName:@"VSVocabularyViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
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
    if ([self.tableView pointInside:point withEvent:nil]) {
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(cell != nil)
        {
            CGPoint origin = cell.frame.origin;
            origin.x += self.tableView.frame.origin.x;
            origin.y += self.tableView.frame.origin.y;
            
            [self initDraggedCellWithCell:cell AtPoint:origin];
            cell.highlighted = NO;
        }

    }
}

- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point
{
    // get rid of old cell, if it wasn't disposed already
    if(draggedView != nil)
    {
        [draggedView removeFromSuperview];
        draggedView = nil;
    }
    
    CGRect frame = CGRectMake(point.x + 320, point.y, cell.frame.size.width, cell.frame.size.height);
    
    draggedView = [[UITableViewCell alloc] init];
    draggedView.frame = frame;
    [draggedView setBackgroundColor:[UIColor redColor]];
    draggedView.alpha = 0.8;
    
    if(cell != nil) {
        [cell.backgroundView addSubview:draggedView];
    }
}

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(draggedView != nil)
    {
        CGPoint translation = [gestureRecognizer translationInView:[draggedView superview]];
        NSLog(@"xxx: %f", translation.x);
        NSLog(@"yyy: %f", translation.y);
        [draggedView setCenter:CGPointMake([draggedView center].x + translation.x,
                                           [draggedView center].y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[draggedView superview]];
    }
}


- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (draggedView != nil)
    {
        [UIView animateWithDuration:2.0f 
                delay:0.0f 
                options:UIViewAnimationCurveLinear 
                animations:^{
                    [draggedView setFrame:CGRectMake(0, 0, draggedView.frame.size.width, draggedView.frame.size.height)];
                }
                completion:^(BOOL finished) {
                    if (finished == YES) {
                        
                    }
                }
        ];
    }
}


@end
