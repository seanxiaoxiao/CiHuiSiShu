//
//  VSVocabularyRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSVocabulary;

@interface VSVocabularyRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * meet;
@property (nonatomic, retain) NSNumber * remember;
@property (nonatomic, retain) NSString * spell;

@property (nonatomic, retain) NSDate *seeSummaryStart;
@property (nonatomic, retain) VSVocabulary *cacheVocabulary;
@property (nonatomic, assign) int seeSummaryTimes;

- (void) initWithVocabulary:(VSVocabulary *)vocabulary;

- (VSVocabulary *)getVocabulary;

- (void)seeSummary;

- (void)remembered;

- (void)forgot;

- (void)finishSummary;

- (BOOL)rememberWell;

- (BOOL)rememberNotWell;

- (BOOL)rememberBad;

@end
