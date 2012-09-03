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
@synthesize contactContents;
@synthesize infoLabel;

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
    self.title = @"设置";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    contactContents = [NSArray arrayWithObjects:@"给词汇私塾评分", @"意见反馈", nil];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImage* backImage= [VSUtils fetchImg:@"NavBackButton"];
    CGRect frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (GUIDE_SECTION == section) {
        return 1;
    }
    else if (CONTACT_SECTION == section) {
        return [contactContents count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ( section == CONTACT_SECTION ) {
		NSString* versionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		return [NSString stringWithFormat:@"\n\n词汇私塾\nVersion %@\nXiao Xiao -- Direct\nSu Shaowen -- Art\n©2012 GeFo Studio", versionNum];
	}
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Contact";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if (GUIDE_SECTION == indexPath.section) {
        cell.textLabel.text = @"使用向导";
    }
    else if (CONTACT_SECTION == indexPath.section) {
        cell.textLabel.text = [contactContents objectAtIndex:indexPath.row];
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
    if (indexPath.section == GUIDE_SECTION) {
        if (indexPath.row == GUIDE) {
            [VSUtils showGuidPage];
        }
    }
    else if (indexPath.section == CONTACT_SECTION) {
        if (indexPath.row == RATEUS) {
            [self voteOnAppStore];
        }
        else if (indexPath.row == FEADBACK) {
            [self sendFeedbackFrom:self];
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == GUIDE_SECTION) {
        return @"用户指南";
    }
    else if (section == CONTACT_SECTION) {
        return @"联系我们";
    }
    return @"";
}

- (void)voteOnAppStore
{
    [ [ UIApplication sharedApplication ] openURL: [ NSURL URLWithString: [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"558382812"] ] ];
}

- (void)sendFeedbackFrom:(UIViewController *)controller
{
    if ( [ MFMailComposeViewController canSendMail ] ) {
        UIDevice *device = [ UIDevice currentDevice ];
        MFMailComposeViewController *mailController =  [ [ MFMailComposeViewController alloc ] init ];
        mailController.mailComposeDelegate = self;
        [ mailController setSubject: [ NSString stringWithFormat: @"Feedback - 词汇私塾 "]];// BUNDLE_DISPLAY_NAME, BUNDLE_VERSION, BUNDLE_BUILD_NUMBER ] ];
        [ mailController setToRecipients: [ NSArray arrayWithObject: EMAIL_SUPPORTING ] ];
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* versionNum = [infoDict objectForKey:@"CFBundleVersion"];
        NSString *appName = [infoDict objectForKey:@"CFBundleName"];
        [ mailController setMessageBody: [ NSString stringWithFormat: @"\n\n\n\n\n\nApp: %@\nVersion :%@\nDevice: %@\nSystem: %@\nMTS: %@\nWiFi:\nInternet:\n",appName, versionNum, [ device model ], [ device systemVersion ], IS_MULTITASKING_SUPPORTED ? @"Yes" : @"No" ] isHTML: NO ];
        [ controller presentModalViewController: mailController animated: YES ];
    } else {
        [[[UIAlertView alloc] initWithTitle: @"意外" message: @"邮件没有正确配置" delegate: nil cancelButtonTitle: @"嗯，知道了" otherButtonTitles: nil] show];
    }    
}

#pragma mark - MFMessageComposeViewControllerDelegate methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
		[ [ [ UIAlertView alloc ] initWithTitle: @"邮件发生完毕" message: @"谢谢你的反馈，你是好筒子" delegate: nil cancelButtonTitle: @"嗯，好" otherButtonTitles: nil ] show ];
    } else if (result == MessageComposeResultFailed) {
		[[[UIAlertView alloc] initWithTitle:@"邮件发送失败" message:nil delegate:nil cancelButtonTitle:@"嗯，知道了" otherButtonTitles:nil] show];        
    }
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- ( void ) mailComposeController: ( MFMailComposeViewController * ) controller didFinishWithResult: ( MFMailComposeResult ) result error: ( NSError * ) error {
	if ( result == MFMailComposeResultSent ) {
		[ [ [ UIAlertView alloc ] initWithTitle: @"邮件发生完毕" message: @"谢谢你的反馈，你是好筒子" delegate: nil cancelButtonTitle: @"嗯，好" otherButtonTitles: nil ] show ];
	} else if ( result == MFMailComposeResultFailed ) {
		[ [ [ UIAlertView alloc ] initWithTitle: @"邮件发送失败" message: nil delegate: nil cancelButtonTitle: @"嗯，知道了" otherButtonTitles: nil ] show ];
	}
	[ controller dismissModalViewControllerAnimated: YES ];
}

@end
