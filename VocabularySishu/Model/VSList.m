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
@dynamic finishPlanDate;
@synthesize listRecord;


+ (VSListRecord *)createAndGetHistoryList
{
    return [VSListRecord createAndGetHistoryListRecord];
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
    return [VSListRecord historyListBefore:startAt];
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

- (NSString *)repoCategory
{
    NSRange range;
    if ((range = [self.name rangeOfString:@"GRE"]).location != NSNotFound || (range = [self.name rangeOfString:@"TOEFL"]).location != NSNotFound || (range = [self.name rangeOfString:@"GMAT"]).location != NSNotFound || (range = [self.name rangeOfString:@"IELTS"]).location != NSNotFound || (range = [self.name rangeOfString:@"四级"]).location != NSNotFound || (range = [self.name rangeOfString:@"六级"]).location != NSNotFound) {
        return [NSString stringWithFormat:@"%@", [self.name substringWithRange:range]];
    }
    return @"";
}

- (NSString *)subName
{
    NSRange range;
    if ((range = [self.name rangeOfString:@"GRE"]).location != NSNotFound || (range = [self.name rangeOfString:@"TOEFL"]).location != NSNotFound || (range = [self.name rangeOfString:@"GMAT"]).location != NSNotFound || (range = [self.name rangeOfString:@"IELTS"]).location != NSNotFound || (range = [self.name rangeOfString:@"四级"]).location != NSNotFound || (range = [self.name rangeOfString:@"六级"]).location != NSNotFound) {
        NSRange remainRange;
        remainRange.location = range.length;
        remainRange.length = [self.name length] - range.length;
        return [NSString stringWithFormat:@"%@", [self.name substringWithRange:remainRange]];
    }
    return @"";
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

- (VSListRecord *)getListRecord
{
    VSListRecord *record = [VSListRecord findByListName:self.name];
    return record;
}

@end
