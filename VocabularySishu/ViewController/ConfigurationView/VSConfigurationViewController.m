//
//  VSConfigurationViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 6/15/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSConfigurationViewController.h"
#import "VSUIUtils.h"
#import "VSUtils.h"
#import "VSContext.h"
#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "InAppPurchase.h"

@interface VSConfigurationViewController ()

@end

@implementation VSConfigurationViewController
@synthesize moreContents;
@synthesize infoLabel;
@synthesize toggleSwitch;
@synthesize shareContents;

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
    moreContents = [NSArray arrayWithObjects:@"广告退散", @"使用向导", @"更多系列", @"给词汇私塾评分", @"意见反馈", nil];
    shareContents = [NSArray arrayWithObjects:@"分享到", @"账号中心", nil];
    [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(goBack)]];
    
    // Load store
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(productsDidLoad) name:kProductDataReadyEvent object:nil];
    [nc addObserver:self selector:@selector(productsDidLoadFailed) name:kProductDataMissedEvent object:nil];
    [nc addObserver:self selector:@selector(productPurchaseDidCancel) name:kProductPurchaseCancelled object:nil];
    [nc addObserver:self selector:@selector(productPurchaseDidSuccess:) name:kProductPurchaseSucceeded object:nil];
    [nc addObserver:self selector:@selector(productPurchaseDidFailed) name:kProductPurchaseFailed object:nil];
    
    if (![InAppPurchase canMakePurchase]) {
        [self productsDidLoadFailed];
    } else {
        [InAppPurchase requestProductsData];
    }
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (SHARE_SECTION == section) {
        return [shareContents count];
    }
    else if (MORE_SECTION == section) {
        return [moreContents count];
    }
    else if (SETTING_SECTION == section) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ( section == MORE_SECTION ) {
		NSString* versionNum = [VSUtils getBundleVersion];
		return [NSString stringWithFormat:@"新词汇私塾\nVersion %@\nXiao Xiao -- Direct\nSu Shaowen -- Art\n©2012 - 2014 Innorz", versionNum];
	}
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    if (SETTING_SECTION == indexPath.section) {
        cellIdentifier = @"Settings";
    }
    else {
        cellIdentifier = @"Text";        
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if (SHARE_SECTION == indexPath.section) {
        cell.textLabel.text = [shareContents objectAtIndex:indexPath.row];
    }
    else if (MORE_SECTION == indexPath.section) {
        cell.textLabel.text = [moreContents objectAtIndex:indexPath.row];
    }
    else if (SETTING_SECTION == indexPath.section) {
        cell.textLabel.text = @"翻开后发音";
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        toggleSwitch = [[UISwitch alloc] init];
        cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
        [cell.accessoryView addSubview:toggleSwitch];
        toggleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAfterOpen"];
        [toggleSwitch addTarget:self action:@selector(playAfterOpenPushed) forControlEvents:UIControlEventValueChanged];

    }
    return cell;
}

- (void)playAfterOpenPushed
{
    [[NSUserDefaults standardUserDefaults] setBool:toggleSwitch.on forKey:@"playAfterOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SHARE_SECTION) {
        if (indexPath.row == SHARE_TO) {
            [self share];
        }
        else if (indexPath.row == ACCOUNT_MANAGE) {
            [self accountManage];
        }
    }
    else if (indexPath.section == MORE_SECTION) {
        if (indexPath.row == IAP) {
            [InAppPurchase purchaseProductWithIdentifier:IAPProductIdentifierNoAd];
        }
        else if (indexPath.row == GUIDE) {
            [VSUtils showGuidPage];
        }
        else if (indexPath.row == MORE) {
            [VSUtils openSeries];
        }
        else if (indexPath.row == RATEUS) {
            [self voteOnAppStore];
        }
        else if (indexPath.row == FEEDBACK) {
            [self sendFeedbackFrom:self];
        }
    }
}

- (void)accountManage
{
    UMSocialControllerService *socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:[UMSocialData defaultData]];
    UINavigationController *accountViewController =[socialControllerService getSocialAccountController];
    [self presentModalViewController:accountViewController animated:YES];
}

- (void)share
{
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"ShareTo"];
    NSString *appLink = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", [VSUtils getAppId]];
    socialData.shareText = [NSString stringWithFormat:@"我正在使用 %@ 背单词，我觉得还用起来还不错，各位亲们也来试试吧 %@", [VSUtils getAppName], appLink];
    socialData.shareImage = [UIImage imageNamed:@"icon512.png"];
    UMSocialControllerService *socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    UINavigationController *shareListController = [socialControllerService getSocialShareListController];
    [self presentModalViewController:shareListController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SHARE_SECTION) {
        return @"分享";
    }
    else if (section == MORE_SECTION) {
        return @"更多";
    }
    else if (section == SETTING_SECTION) {
        return @"设置";
    }
    return @"";
}

- (void)voteOnAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [VSUtils getAppId]]]];
}

- (void)sendFeedbackFrom:(UIViewController *)controller
{
    if ([MFMailComposeViewController canSendMail]) {
        UIDevice *device = [ UIDevice currentDevice ];
        MFMailComposeViewController *mailController =  [ [ MFMailComposeViewController alloc ] init ];
        mailController.mailComposeDelegate = self;
        NSString *subject = [NSString stringWithFormat:@"Feedback - %@", [VSUtils getBundleName]];
        [mailController setSubject:subject];
        [mailController setToRecipients: [NSArray arrayWithObject: EMAIL_SUPPORTING]];
        NSString *versionNum = [VSUtils getBundleVersion];
        NSString *appName = [VSUtils getBundleName];
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

#pragma mark - IAP

- (void)productsDidLoad
{
}

- (void)productsDidLoadFailed
{
    [[[UIAlertView alloc] initWithTitle: @"意外！" message: @"广告依然在" delegate: nil cancelButtonTitle: @"嗯，知道了" otherButtonTitles: nil] show];    
}

- (void)productPurchaseDidSuccess:(NSNotification *)notification
{
    [[[UIAlertView alloc] initWithTitle: @"耶！" message: @"广告消失了" delegate: nil cancelButtonTitle: @"嗯，知道了" otherButtonTitles: nil] show];
}

- (void)productPurchaseDidFailed
{
    [[[UIAlertView alloc] initWithTitle: @"意外！" message: @"广告依然在" delegate: nil cancelButtonTitle: @"嗯，知道了" otherButtonTitles: nil] show];
}

- (void)productPurchaseDidCancel
{
}

@end
