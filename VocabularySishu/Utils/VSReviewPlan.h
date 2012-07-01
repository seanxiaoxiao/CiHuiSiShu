//
//  VSReviewPlan.h
//  VocabularySishu
//
//  Created by xiao xiao on 7/1/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSVocabulary.h"
#import "VSList.h"
#import "VSConstant.h"
#import "VSContext.h"

@interface VSReviewPlan : NSObject

+ (VSReviewPlan *)getPlan;

- (void)addVocabulary:(VSVocabulary *)vocabulary;

@property (nonatomic, retain)VSList *shortTermList;

@property (nonatomic, retain)VSList *longTermList;

@end
