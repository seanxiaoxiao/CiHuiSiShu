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

@class VSListVocabulary, VSRepository, VSVocabulary;

@interface VSList : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * isHistory;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *listVocabularies;
@property (nonatomic, retain) VSRepository *repository;

+ (VSList *)createAndGetHistoryList;

+ (NSArray *)lastestHistoryList;

+ (void)recitedVocabulary:(VSVocabulary *)vocabulary;

- (float)finishRate;

- (int)rememberedCount;

- (int)forgotCount;

@end

@interface VSList (CoreDataGeneratedAccessors)

- (void)addListVocabulariesObject:(VSListVocabulary *)value;
- (void)removeListVocabulariesObject:(VSListVocabulary *)value;
- (void)addListVocabularies:(NSSet *)values;
- (void)removeListVocabularies:(NSSet *)values;
@end

