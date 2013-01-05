//
//  VSContext.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSContext.h"
#import "VSList.h"
#import "VSListVocabulary.h"
#import "VSRepository.h"


@implementation VSContext

@dynamic currentList;
@dynamic currentListVocabulary;
@dynamic currentRepository;
@dynamic playAfterOpen;

+ (VSContext *)getContext
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *contextDescription = [NSEntityDescription entityForName:@"VSContext" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *contextRequest = [[NSFetchRequest alloc] init];
    [contextRequest setEntity:contextDescription];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:contextRequest error:&error];
    if ([results count] > 0) {
        VSContext *context = [results objectAtIndex:0];
        if (context.currentList == nil) {
            context.currentList = [VSList firstList];
            context.currentRepository = context.currentList.repository;
            [VSUtils saveEntity];
        }
        return [results objectAtIndex:0];
    }
    else {
        VSContext *context = [NSEntityDescription insertNewObjectForEntityForName:@"VSContext" inManagedObjectContext:[VSUtils currentMOContext]];
        context.currentList = [VSList firstList];
        context.currentRepository = context.currentList.repository;
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        return context;
    }
}


+ (BOOL)isFirstTime
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *contextDescription = [NSEntityDescription entityForName:@"VSContext" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *contextRequest = [[NSFetchRequest alloc] init];
    [contextRequest setEntity:contextDescription];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:contextRequest error:&error];
    return ([results count] == 0 || ((VSContext *)[results objectAtIndex:0]).currentList == nil);
}

- (void)fixCurrentList:(VSList *)list
{
    self.currentList = list;
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)fixRepository:(VSRepository *)repo
{
    self.currentRepository = repo;
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
