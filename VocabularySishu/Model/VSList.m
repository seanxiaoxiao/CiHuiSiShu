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

@implementation VSList

@dynamic createdDate;
@dynamic type;
@dynamic name;
@dynamic order;
@dynamic listVocabularies;
@dynamic repository;
@dynamic status;


+ (VSList *)createAndGetHistoryList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSDate *today = [VSUtils getToday];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(createdDate >= %@)", [NSDate dateWithTimeIntervalSinceNow:-86400]];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type = 1)"];
    [listRequest setPredicate:isHistoryPredicate];
    [listRequest setPredicate:datePredicate];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    else {
        VSList *listForToday = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
        NSCalendar *nowCalendar = [NSCalendar currentCalendar];
        NSDateComponents *nowComponents = [nowCalendar components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
        listForToday.name = [NSString stringWithFormat:@"%d月%d日背诵List", [nowComponents month], [nowComponents day ]];
        listForToday.order = [NSNumber numberWithInt:-1];
        listForToday.type = [VSConstant LIST_TYPE_HISTORY];
        listForToday.repository = nil;
        listForToday.createdDate = today;
        listForToday.status = [VSConstant LIST_STATUS_NEW];
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        return listForToday;
    }
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
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSString *predicateContent = [NSString stringWithFormat:@"(name=='GRE顺序List1')"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    return [array objectAtIndex:0];
}

+ (NSArray *)lastestHistoryList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    listRequest.fetchLimit = 7;
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type=1)"];
    [listRequest setPredicate:isHistoryPredicate];
    NSArray *tempResult = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[tempResult count]];
    for (VSList *list in tempResult) {
        if ([list.listVocabularies count] > 0) {
            [result addObject:list];
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

+ (void)recitedVocabulary:(VSVocabulary *)vocabulary
{
    VSList *listForToday = [VSList createAndGetHistoryList];
    if (![listForToday hasVocabulary:vocabulary]) {
        [VSListVocabulary create:listForToday withVocabulary:vocabulary];
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

- (BOOL)isHistoryList
{
    return [self.type intValue] == 1;
}

- (float)finishProgress
{
    int rememberedCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[VSConstant VOCABULARY_LIST_STATUS_REMEMBERED]]) {
            rememberedCount++;
        }
    }
    return (float)(rememberedCount) / (float)([self.listVocabularies count]);
}

- (int)rememberedCount
{
    int rememberedCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[VSConstant VOCABULARY_LIST_STATUS_REMEMBERED]]) {
            rememberedCount++;
        }
    }
    return rememberedCount;
}

- (int)forgotCount
{
    int forgotCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[VSConstant VOCABULARY_LIST_STATUS_FORGOT]]) {
            forgotCount++;
        }
    }
    return forgotCount;    
}

- (void)process
{
    __autoreleasing NSError *error = nil;
    self.status = [VSConstant LIST_STATUS_PROCESSING];
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)finish
{
    __autoreleasing NSError *error = nil;
    self.status = [VSConstant LIST_STATUS_FINISH];
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray *)vocabulariesToRecite
{
    NSMutableArray *results = nil;
    if (![self.type isEqualToNumber:[VSConstant LIST_TYPE_NORMAL]]) {
        NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSSortDescriptor *sortStatusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastStatus" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, sortStatusDescriptor, nil];
        results = [NSMutableArray arrayWithArray:[self.listVocabularies sortedArrayUsingDescriptors:sortDescriptors]];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lastStatus!=1)"];
        NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSSortDescriptor *sortStatusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastStatus" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, sortStatusDescriptor, nil];
        results = [NSMutableArray arrayWithArray:[[self.listVocabularies filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors]];
    }
    [results shuffle];
    return results;
}

- (NSArray *)allVocabularies
{
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[self.listVocabularies allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)addVocabulary:(VSVocabulary *)vocabulary
{
    for (VSListVocabulary *listVocabulary in self.listVocabularies) {
        if ([VSUtils vocabularySame:vocabulary with:listVocabulary.vocabulary]) {
            return;
        }
    }
    [VSListVocabulary create:self withVocabulary:vocabulary];
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


- (void)clearVocabularyStatus
{
    for (VSListVocabulary *listVocabualry in self.listVocabularies) {
        listVocabualry.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
    }
    [VSUtils saveEntity];
}

- (BOOL)shortTermExpire
{
    NSDate *now = [VSUtils getNow];
    return [[VSConstant LIST_TYPE_SHORTTERM_REVIEW] isEqualToNumber:self.type] && -[self.createdDate timeIntervalSinceDate:now] >= SHORTTERM_EXPIRE_INTERVAL;
}

- (BOOL)longTermExpire
{
    NSDate *now = [VSUtils getNow];
    return [[VSConstant LIST_TYPE_LONGTERM_REVIEW] isEqualToNumber:self.type] && -[self.createdDate timeIntervalSinceDate:now] >= LONGTERM_EXPIRE_INTERVAL;
}

- (BOOL)isFirst
{
    NSLog(@"Order %@", self.order);
    return [self.order intValue] == 1;
}

- (BOOL)isLast
{
    return [self.order intValue] == [[self.repository lists] count];
}

@end
