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
@class VSListRecord;

@interface VSList : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *listVocabularies;
@property (nonatomic, retain) VSRepository *repository;
@property (nonatomic, retain) NSDate * finishPlanDate;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) VSListRecord * listRecord;

+ (VSListRecord *)createAndGetHistoryList;

+ (NSArray *)lastestHistoryList;

+ (NSArray *)historyListBefore:(NSDate *)startAt;

+ (VSList *)firstList;

- (NSArray *)allVocabularies;

- (BOOL)isHistoryList;

- (VSList *)nextList;

- (VSList *)previousList;

- (BOOL)isFirst;

- (BOOL)isLast;

- (NSString *)displayName;

- (NSString *)titleName;

- (void)initListRecord;

- (VSListRecord *)getListRecord;

@end

@interface VSList (CoreDataGeneratedAccessors)

- (void)addListVocabulariesObject:(VSListVocabulary *)value;
- (void)removeListVocabulariesObject:(VSListVocabulary *)value;
- (void)addListVocabularies:(NSSet *)values;
- (void)removeListVocabularies:(NSSet *)values;
@end

