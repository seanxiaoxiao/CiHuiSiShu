//
//  VSAlertDelegate.h
//  VocabularySishu
//
//  Created by xiao xiao on 6/13/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSList.h"
#import "VSContext.h"
#import "VSVocabularyListViewController.h"
#import "VSRepository.h"

@interface VSAlertDelegate : NSObject<UIAlertViewDelegate>

@property (nonatomic, retain)VSList *currentList;

@end