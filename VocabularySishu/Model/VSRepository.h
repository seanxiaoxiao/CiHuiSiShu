//
//  VSRepository.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "VSList.h"
#import "VSConstant.h"

@class VSList;

@interface VSRepository : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * finishedRound;
@property (nonatomic, retain) NSSet *lists;

+ (NSArray *)allRepos;

- (void)finishThisRound;

- (NSArray *)orderedList;

- (VSList *)firstListInRepo;

- (int) wordsTotal;

@end

@interface VSRepository (CoreDataGeneratedAccessors)

- (void)addListsObject:(VSList *)value;
- (void)removeListsObject:(VSList *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;
@end

