//
//  VSList.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSUtils.h"
#import "VSVocabulary.h"
#import "VSUtils.h"
#import "NSMutableArrayShuffling.h"

@class VSListVocabulary, VSRepository, VSVocabulary;

@interface VSList : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *listVocabularies;
@property (nonatomic, retain) VSRepository *repository;
@property (nonatomic, retain) NSNumber * round;

+ (VSList *)createAndGetHistoryList;

+ (NSArray *)lastestHistoryList;

+ (NSArray *)historyListBefore:(NSDate *)startAt;

+ (VSList *)latestLongTermReviewList;

+ (VSList *)latestShortTermReviewList;

+ (VSList *)createAndGetShortTermReviewList;

+ (VSList *)createAndGetLongTermReviewList;

+ (void)recitedVocabulary:(VSVocabulary *)vocabulary;

+ (VSList *)firstList;

- (double)finishProgress;

- (NSArray *)vocabulariesToRecite;

- (NSArray *)allVocabularies;

- (void)addVocabulary:(VSVocabulary *)vocabulary;

- (BOOL)isHistoryList;

- (VSList *)nextList;

- (VSList *)previousList;

- (void)process;

- (void)finish;

- (void)clearVocabularyStatus;

- (BOOL)shortTermExpire;

- (BOOL)longTermExpire;

- (BOOL)isFirst;

- (BOOL)isLast;

- (double)notWellRate;

- (double)rememberRate;

- (NSString *)displayName;

@end

@interface VSList (CoreDataGeneratedAccessors)

- (void)addListVocabulariesObject:(VSListVocabulary *)value;
- (void)removeListVocabulariesObject:(VSListVocabulary *)value;
- (void)addListVocabularies:(NSSet *)values;
- (void)removeListVocabularies:(NSSet *)values;
@end

