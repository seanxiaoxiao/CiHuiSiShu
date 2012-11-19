//
//  VSListRecord.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSListRecord.h"
#import "VSList.h"
#import "VSListVocabularyRecord.h"
#import "VSVocabularyRecord.h"

@implementation VSListRecord

@dynamic createdDate;
@dynamic finishPlanDate;
@dynamic name;
@dynamic rememberCount;
@dynamic round;
@dynamic status;
@dynamic type;
@dynamic listVocabularies;

- (void)initWithVSList:(VSList *)list
{
    self.createdDate = list.createdDate;
    self.finishPlanDate = list.finishPlanDate;
    self.name = list.name;
    self.round = list.round;
    self.status = list.status;
    self.type = list.type;
}

+ (VSListRecord *)createAndGetHistoryListRecord
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSDate *now = [VSUtils getNow];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(createdDate >= %@ AND createdDate <= %@)", [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:now], now];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type == 1)"];
    [listRequest setPredicate:isHistoryPredicate];
    [listRequest setPredicate:datePredicate];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    else {
        NSDate *today = [VSUtils getToday];
        VSListRecord *listForToday = [NSEntityDescription insertNewObjectForEntityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
        NSDate *rightNow = [[NSDate alloc] init];
        NSCalendar *nowCalendar = [NSCalendar currentCalendar];
        NSDateComponents *nowComponents = [nowCalendar components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:rightNow];
        listForToday.name = [NSString stringWithFormat:@"%d月%d日", [nowComponents month], [nowComponents day ]];
        listForToday.type = [VSConstant LIST_TYPE_HISTORY];
        listForToday.createdDate = today;
        listForToday.status = [VSConstant LIST_STATUS_NEW];
        listForToday.round = [NSNumber numberWithInt:0];
        [VSUtils saveEntity];
        return listForToday;
    }
}

+ (NSArray *)lastestHistoryList
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    [listRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]]];
    NSPredicate *isHistoryPredicate = [NSPredicate predicateWithFormat:@"(type = 1)"];
    [listRequest setPredicate:isHistoryPredicate];
    NSArray *tempResult = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[tempResult count]];
    for (VSListRecord *list in tempResult) {
        if ([list.listVocabularies count] > 0) {
            [result addObject:list];
        }
        if ([result count] == 4) {
            break;
        }
    }
    return result;
}

+ (VSListRecord *)findByListName: (NSString *)listName
{
    NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name = %@)", listName];
    [listRequest setPredicate:predicate];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    return nil;
}

+ (VSListRecord *)createdListRecord:(VSList *)list
{
    VSListRecord *listRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    listRecord.name = list.name;
    listRecord.type = list.type;
    listRecord.status = list.status;
    listRecord.round = [NSNumber numberWithInt:0];
    for (VSListVocabulary *listVocabulary in [list allVocabularies]) {
        VSVocabulary *vocabulary = listVocabulary.vocabulary;
        VSVocabularyRecord *vocabularyRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
        [vocabularyRecord initWithVocabulary:vocabulary];
        VSListVocabularyRecord *listVocabularyRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
        [listVocabularyRecord initWithListVocabulary:listVocabulary];
        listVocabularyRecord.vocabularyRecord = vocabularyRecord;
        listVocabularyRecord.listRecord = listRecord;
    }
    [VSUtils saveEntity];
    return listRecord;
}

- (double)notWellRate
{
    int notWellCount = 0;
    for (VSListVocabularyRecord *listVocabulay in self.listVocabularies) {
        if (![listVocabulay.vocabularyRecord rememberWell]) {
            notWellCount++;
        }
    }
    return [self.listVocabularies count] == 0 ? 0.0 : (double)(notWellCount) / (double)([self.listVocabularies count]);
}

- (BOOL)isHistoryList
{
    return [self.type intValue] == 1;
}

- (void)process
{
    __autoreleasing NSError *error = nil;
    self.status = [VSConstant LIST_STATUS_PROCESSING];
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray *)vocabulariesToRecite
{
    NSError *error = nil;
    NSMutableArray *results = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSListVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(listRecord = %@ AND lastStatus != 1)", self];
    [request setPredicate:predicate];
    [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"vocabularyRecord"]];
    [request setEntity:entityDescription];
    results = [NSMutableArray arrayWithArray:[[VSUtils currentMOContext] executeFetchRequest:request error:&error]];
    [results shuffle];
    return results;
}

- (double)finishProgress
{
    int rememberedCount = 0;
    for (VSListVocabulary *listVocabulay in self.listVocabularies) {
        if ([listVocabulay.lastStatus isEqualToNumber:[VSConstant VOCABULARY_LIST_STATUS_REMEMBERED]]) {
            rememberedCount++;
        }
    }
    return (double)(rememberedCount) / (double)([self.listVocabularies count]);
}

- (void)finish
{
    __autoreleasing NSError *error = nil;
    self.status = [VSConstant LIST_STATUS_FINISH];
    self.round = [NSNumber numberWithInt:[self.round intValue] + 1];
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)addVocabulary:(VSVocabularyRecord *)vocabulary
{
    for (VSListVocabularyRecord *listVocabulary in self.listVocabularies) {
        if ([vocabulary.spell isEqualToString:listVocabulary.vocabularyRecord.spell]) {
            listVocabulary.lastRememberStatus = [vocabulary rememberWell] ? [VSConstant REMEMBER_STATUS_GOOD] : [VSConstant REMEMBER_STATUS_BAD];
            [VSUtils saveEntity];
            return;
        }
    }
    [VSListVocabularyRecord create:self withVocabulary:vocabulary];
}


- (void)clearVocabularyStatus
{
    for (VSListVocabulary *listVocabualry in self.listVocabularies) {
        listVocabualry.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
        listVocabualry.lastRememberStatus = nil;
    }
    self.rememberCount = [NSNumber numberWithInt:0];
    [VSUtils saveEntity];
}

- (double)rememberRate
{
    return 1 - [self notWellRate];
}

- (VSList *)getList
{
    NSError *error = nil;
    NSEntityDescription *listDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name = %@)", self.name];
    [listRequest setPredicate:predicate];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:listRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    return nil;
}


@end
