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

#define CONTACT_SECTION 1
#define GUIDE_SECTION 0
#define GUIDE 0
#define RATEUS 0
#define FEADBACK 1
#define EMAIL_SUPPORTING @"seanxiaoxiao@hotmail.com"

#define IS_IOS5_AND_PLUS			( [ [ [ UIDevice currentDevice ] systemVersion ] compare: @"5.0" options: NSNumericSearch ] != NSOrderedAscending )
#define IS_IOS4_AND_PLUS			( [ [ [ UIDevice currentDevice ] systemVersion ] compare: @"4.0" options: NSNumericSearch ] != NSOrderedAscending )
#define IS_RETINA_DISPLAY			( [ UIScreen instancesRespondToSelector: @selector ( scale ) ] ? ( [ [ UIScreen mainScreen ] scale ] == 2 ) : NO )
#define IS_MULTITASKING_SUPPORTED	( [ UIDevice instancesRespondToSelector: @selector ( isMultitaskingSupported ) ] ? ( [ UIDevice currentDevice ].multitaskingSupported ) : NO )


@interface VSConfigurationViewController : UITableViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) NSArray *contactContents;
@property (nonatomic, retain) UILabel *infoLabel;

@end
