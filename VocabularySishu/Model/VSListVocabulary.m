//
//  VSListVocabulary.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSListVocabulary.h"
#import "VSList.h"
#import "VSVocabulary.h"
#import "VSConstant.h"


@implementation VSListVocabulary

@dynamic lastStatus;
@dynamic order;
@dynamic list;
@dynamic vocabulary;

+ (void)create:(VSList *)theList withVocabulary:(VSVocabulary *)theVocabulary
{
    int newOrder = [theList.listVocabularies count];
    VSListVocabulary *newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    newRecord.lastStatus = [NSNumber numberWithInt:VOCABULARY_LIST_STATUS_NEW];
    newRecord.order = [NSNumber numberWithInt:newOrder];
    newRecord.list = theList;
    newRecord.vocabulary = theVocabulary;
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)remembered
{
    self.lastStatus = [NSNumber numberWithInt:VOCABULARY_LIST_STATUS_REMEMBERED];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)forgot
{
    self.lastStatus = [NSNumber numberWithInt:VOCABULARY_LIST_STATUS_FORGOT];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


@end
