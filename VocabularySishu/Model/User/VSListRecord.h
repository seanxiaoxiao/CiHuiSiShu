//
//  VSListRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSList.h"
#import "VSVocabularyRecord.h"

@interface VSListRecord : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * finishPlanDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rememberCount;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet * listVocabularies;

- (void)initWithVSList: (VSList *)list;

- (VSList *)getList;

+ (VSListRecord *)createAndGetHistoryListRecord;

+ (VSListRecord *)findByListName: (NSString *)listName;

+ (VSListRecord *)createdListRecord: (VSList *)list;

+ (NSArray *)lastestHistoryList;

- (double)notWellRate;

- (BOOL)isHistoryList;

- (void)process;

- (NSMutableArray *)vocabulariesToRecite;

- (double)finishProgress;

- (void)finish;

- (void)addVocabulary:(VSVocabularyRecord *)vocabulary;

- (void)clearVocabularyStatus;

- (double)rememberRate;

- (void)setPlanFinishDate:(int)daysToFinish;

- (void)resetFinishPlanDate;

@end
