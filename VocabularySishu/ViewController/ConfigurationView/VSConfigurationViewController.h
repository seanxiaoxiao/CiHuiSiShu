//
//  VSConfigurationViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 6/15/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSRepository.h"
#import "VSList.h"
#import "VSContext.h"

@interface VSConfigurationViewController : UITableViewController

@property (nonatomic, assign)int selectedListIndex;
@property (nonatomic, retain)NSMutableArray *listSelectRecords;

@end
