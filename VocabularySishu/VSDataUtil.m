//
//  VSDataUtil.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSDataUtil.h"

@implementation VSDataUtil

+ (void)initRepoData
{
    NSManagedObjectContext *context = [VSUtils currentMOContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repository" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (int i = 0; i < [array count]; i++) {
        Repository *repo = [array objectAtIndex:i];
        [context deleteObject:repo];
    }

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Repos" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *repoArray = [parser objectWithString:jsonString];
    for (int i = 0; i < [repoArray count]; i++) {
        Repository *repo = [NSEntityDescription insertNewObjectForEntityForName:@"Repository" inManagedObjectContext:[VSUtils currentMOContext]];
        repo.name = [repoArray objectAtIndex:i];
        repo.order = [NSNumber numberWithInt:i];
        __autoreleasing NSError *error = nil;
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }        
    }
}

+ (void)initRepoList
{
    NSManagedObjectContext *context = [VSUtils currentMOContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"List" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (int i = 0; i < [array count]; i++) {
        List *repoList = [array objectAtIndex:i];
        [context deleteObject:repoList];
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Lists" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *repoListDict = [parser objectWithString:jsonString];
    NSArray *repoListKeys = [repoListDict allKeys];
    for (NSString *key in repoListKeys) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Repository" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSString *predicateContent = [NSString stringWithFormat:@"(name=='%@')", key];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
        [request setPredicate:predicate];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        Repository *repository = [array objectAtIndex:0];
        NSArray *repoLists = [repoListDict objectForKey:key];
        for (int i = 0; i < [repoLists count]; i++) {
            List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[VSUtils currentMOContext]];
            list.name = [repoLists objectAtIndex:i];
            list.order = [NSNumber numberWithInt:i];
            list.repository = repository;
            __autoreleasing NSError *error = nil;
            if (![[VSUtils currentMOContext] save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}

+ (void)initData
{
    [VSDataUtil initRepoData];
}


@end
