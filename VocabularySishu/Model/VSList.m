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
@dynamic isHistory;
@dynamic name;
@dynamic order;
@dynamic listVocabularies;
@dynamic repository;


+ (VSList *)createAndGetHistoryList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSDate *today = [VSUtils getToday];
    NSString *datePredicateContent = [NSString stringWithFormat:@"(createdDate=='%@')", today];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:datePredicateContent];
    [listRequest setPredicate:datePredicate];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(isHistory=1)"];
    [listRequest setPredicate:isHistoryPredicate];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        NSLog(@"Existed history list");
        return [results objectAtIndex:0];
    }
    else {
        NSLog(@"New history list");
        VSList *listForToday = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
        NSCalendar *nowCalendar = [NSCalendar currentCalendar];
        NSDateComponents *nowComponents = [nowCalendar components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
        listForToday.name = [NSString stringWithFormat:@"%d月%d日背诵List", [nowComponents month], [nowComponents day ]];
        listForToday.order = [NSNumber numberWithInt:-1];
        listForToday.isHistory = [NSNumber numberWithInt:1];
        listForToday.repository = nil;
        listForToday.createdDate = today;
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        return listForToday;
    }
}

+ (NSArray *)lastestHistoryList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    listRequest.fetchLimit = 7;
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(isHistory=1)"];
    [listRequest setPredicate:isHistoryPredicate];
    return [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
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
    return [self.isHistory intValue] == 1;
}

- (float)finishProgress
{
    int rememberedCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[NSNumber numberWithInt:VOCABULARY_LIST_STATUS_REMEMBERED]]) {
            rememberedCount++;
        }
    }
    return (float)(rememberedCount) / (float)([self.listVocabularies count]);
}

- (int)rememberedCount
{
    int rememberedCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[NSNumber numberWithInt:VOCABULARY_LIST_STATUS_REMEMBERED]]) {
            rememberedCount++;
        }
    }
    return rememberedCount;
}

- (int)forgotCount
{
    int forgotCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[NSNumber numberWithInt:VOCABULARY_LIST_STATUS_FORGOT]]) {
            forgotCount++;
        }
    }
    return forgotCount;    
}

- (NSArray *)vocabulariesToRecite
{
    if (self.isHistory) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lastStatus!='1')"];
        NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSSortDescriptor *sortStatusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastStatus" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, sortStatusDescriptor, nil];
        return [[self.listVocabularies filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lastStatus!=1)"];
        NSSortDescriptor *sortSpellDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vocabulary.spell" ascending:YES];
        NSSortDescriptor *sortStatusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastStatus" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortSpellDescriptor, sortStatusDescriptor, nil];
        return [[self.listVocabularies filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors];
    }
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
    NSNumber *nextOrder = [NSNumber numberWithInt:([self.order intValue] + 1)];
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSString *repoPredicateContent = [NSString stringWithFormat:@"(repository==%@)", self.repository];
    NSPredicate *repoPredicate = [NSPredicate predicateWithFormat:repoPredicateContent];
    NSString *orderPredicateContent = [NSString stringWithFormat:@"(order=%@)", nextOrder];
    NSPredicate *orderPredicate = [NSPredicate predicateWithFormat:orderPredicateContent];
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"(isHistory!=1)"];
    [listRequest setPredicate:repoPredicate];
    [listRequest setPredicate:orderPredicate];
    [listRequest setPredicate:historyPredicate];
    __autoreleasing NSError *error = nil;
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    return [results count] > 0 ? [results objectAtIndex:0] : nil;
}

@end
