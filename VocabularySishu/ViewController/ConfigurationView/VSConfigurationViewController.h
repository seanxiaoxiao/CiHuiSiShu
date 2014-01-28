//
//  VSConfigurationViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 6/15/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "VSRepository.h"
#import "VSList.h"
#import "VSContext.h"

#define MORE_SECTION 2
#define SETTING_SECTION 0
#define SHARE_SECTION 1

#define SHARE_TO 0
#define ACCOUNT_MANAGE 1

#define IAP 0
#define GUIDE 1
#define MORE 2
#define RATEUS 3
#define FEEDBACK 4
#define EMAIL_SUPPORTING @"vss@gefostudio.com"

#define IS_IOS5_AND_PLUS			( [ [ [ UIDevice currentDevice ] systemVersion ] compare: @"5.0" options: NSNumericSearch ] != NSOrderedAscending )
#define IS_IOS4_AND_PLUS			( [ [ [ UIDevice currentDevice ] systemVersion ] compare: @"4.0" options: NSNumericSearch ] != NSOrderedAscending )
#define IS_RETINA_DISPLAY			( [ UIScreen instancesRespondToSelector: @selector ( scale ) ] ? ( [ [ UIScreen mainScreen ] scale ] == 2 ) : NO )
#define IS_MULTITASKING_SUPPORTED	( [ UIDevice instancesRespondToSelector: @selector ( isMultitaskingSupported ) ] ? ( [ UIDevice currentDevice ].multitaskingSupported ) : NO )


@interface VSConfigurationViewController : UITableViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) NSArray *moreContents;
@property (nonatomic, retain) NSArray *shareContents;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UISwitch *toggleSwitch;

@end
