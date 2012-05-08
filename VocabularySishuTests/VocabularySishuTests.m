//
//  VocabularySishuTests.m
//  VocabularySishuTests
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VocabularySishuTests.h"
#import "VSUtils.h"
#import "Vocabulary.h"

@implementation VocabularySishuTests

- (void)setUp
{
    [super setUp];
    NSManagedObjectContext *context = [VSUtils currentMOContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (int i = 0; i < [array count]; i++) {
        Vocabulary *vocabulary = [array objectAtIndex:i];
        NSLog(@"%@", [vocabulary objectID]);
        NSLog(@"%@", [array objectAtIndex:i]);
        [context deleteObject:vocabulary];
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testCreateVocabulary
{
    Vocabulary *newVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    newVocabulary.spell = @"apple";
    newVocabulary.meet = [NSNumber numberWithInt:0];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    STAssertEquals(@"apple", newVocabulary.spell, @"");
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(spell=='apple')"];
    [request setPredicate:predicate];
    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    STAssertTrue([array count] == 1, @"Have one object");
}

- (void)testUpdateVocabluary
{
}

@end
