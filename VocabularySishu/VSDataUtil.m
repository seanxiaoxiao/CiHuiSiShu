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
    
}

+ (void)initData
{
    [VSDataUtil initRepoData];
}


@end
