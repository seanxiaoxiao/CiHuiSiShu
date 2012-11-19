//
//  VSList.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSList.h"
#import "VSListVocabulary.h"
#import "VSRepository.h"
#import "VSConstant.h"
#import "VSListRecord.h"

@implementation VSList

@dynamic createdDate;
@dynamic type;
@dynamic name;
@dynamic order;
@dynamic listVocabularies;
@dynamic repository;
@dynamic status;
@dynamic round;
@dynamic rememberCount;
@dynamic finishPlanDate;
@synthesize listRecord;


+ (VSListRecord *)createAndGetHistoryList
{
    return [VSListRecord createAndGetHistoryListRecord];
}

+ (VSList *)createAndGetShortTermReviewList
{
    VSList *shortTermList = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    shortTermList.order = [NSNumber numberWithInt:-1];
    shortTermList.type = [VSConstant LIST_TYPE_SHORTTERM_REVIEW];
    shortTermList.repository = nil;
    shortTermList.createdDate = [VSUtils getNow];
    shortTermList.status = [VSConstant LIST_STATUS_NEW];
    [VSUtils saveEntity];
    return shortTermList;
}

+ (VSList *)createAndGetLongTermReviewList
{
    VSList *longTermList = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    longTermList.order = [NSNumber numberWithInt:-1];
    longTermList.type = [VSConstant LIST_TYPE_LONGTERM_REVIEW];
    longTermList.repository = nil;
    longTermList.createdDate = [VSUtils getNow];
    longTermList.status = [VSConstant LIST_STATUS_NEW];
    [VSUtils saveEntity];
    return longTermList;    
}


+ (VSList *)firstList
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSRepository" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    VSRepository *firstRepo = [[array sortedArrayUsingDescriptors:sortDescriptors] objectAtIndex:0];
    return [firstRepo firstListInRepo];;
}

+ (NSArray *)lastestHistoryList
{
    return [VSListRecord lastestHistoryList];
}

+ (NSArray *)historyListBefore:(NSDate *)startAt
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    NSPredicate *createDatePredicate = [NSPredicate predicateWithFormat:@"(createdDate < %@)", startAt];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type = 1)"];
    [listRequest setPredicate:isHistoryPredicate];
    [listRequest setPredicate:createDatePredicate];
    NSArray *tempResult = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[tempResult count]];
    for (VSList *list in tempResult) {
        if ([list.listVocabularies count] > 0) {
            [result addObject:list];
        }
        if ([result count] == 4) {
            break;
        }
    }
    return result;
}

+ (VSList *)latestShortTermReviewList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type = 2)"];
    [listRequest setPredicate:isHistoryPredicate];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    else {
        return nil;
    }
}

+ (VSList *)latestLongTermReviewList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type = 3)"];
    [listRequest setPredicate:isHistoryPredicate];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    else {
        return nil;
    }
}

- (BOOL)hasVocabulary:(VSVocabulary *)theVocabulary
{
    for (VSListVocabulary *listVocabualry in self.listVocabularies) {
        if ([theVocabulary.spell isEqualToString:listVocabualry.vocabulary.spell]) {
            return YES;
        }
    }
    return NO;
}


- (NSArray *)allVocabularies
{
    NSError *error = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(list = %@)", self];
    [request setPredicate:predicate];
    [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"vocabulary"]];
    [request setEntity:entityDescription];
    return [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
}


- (VSList *)nextList
{
    int allListsCount = [self.repository.lists count];
    NSNumber *nextOrder = [NSNumber numberWithInt:([self.order intValue] + 1) % allListsCount];
    
    NSPredicate *orderPredicate = [NSPredicate predicateWithFormat:@"(order = %@)", nextOrder];
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"(type = 0)"];
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"NOT (status = 2)"];
    NSArray *results = [[[[self.repository.lists allObjects] filteredArrayUsingPredicate:orderPredicate] filteredArrayUsingPredicate:historyPredicate] filteredArrayUsingPredicate:statusPredicate];
    return [results count] > 0 ? [results objectAtIndex:0] : nil;
}

- (VSList *)previousList
{
    int allListsCount = [self.repository.lists count];
    NSNumber *nextOrder = [NSNumber numberWithInt:([self.order intValue] - 1) % allListsCount];

    NSPredicate *orderPredicate = [NSPredicate predicateWithFormat:@"(order = %@)", nextOrder];
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"(type = 0)"];
    NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"NOT (status = 2)"];
    NSArray *results = [[[[self.repository.lists allObjects] filteredArrayUsingPredicate:orderPredicate] filteredArrayUsingPredicate:historyPredicate] filteredArrayUsingPredicate:statusPredicate];
    return [results count] > 0 ? [results objectAtIndex:0] : nil;
}

- (BOOL)isFirst
{
    return [self.order intValue] == 1;
}

- (BOOL)isLast
{
    return [self.order intValue] == [[self.repository lists] count];
}


- (NSString *)displayName
{
    if (([self.name rangeOfString:@"TOEFL分类-"].location) != NSNotFound) {
        return [self.name substringFromIndex:[self.name rangeOfString:@"TOEFL分类-"].length];
    }
    else if ([self.repository.name rangeOfString:@"分类"].location == NSNotFound) {
        return [self.order stringValue];
    }
    else {
        return self.name;
    }
}

- (NSString *)titleName
{
    if ([self isHistoryList]) {
        return self.name;
    }
    else if ([self.repository isCategoryRepo]) {
        return self.name;
    }
    else {
        return [NSString stringWithFormat:@"%@ %@", self.repository.name, self.order];
    }
}

- (void)initListRecord
{
    if (![self isHistoryList]) {
        VSListRecord *record = [VSListRecord findByListName:self.name];
        if (record == nil) {
            record = [VSListRecord createdListRecord:self];
        }
        self.listRecord = record;
    }
}

- (BOOL)isHistoryList
{
    return [self.type intValue] == 1;
}
@end
