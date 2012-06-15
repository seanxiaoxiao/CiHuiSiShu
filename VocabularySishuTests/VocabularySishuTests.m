//
//  VocabularySishuTests.m
//  VocabularySishuTests
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VocabularySishuTests.h"
#import "VSUtils.h"
#import "VSList.h"
#import "VSRepository.h"
#import "VSVocabulary.h"

@implementation VocabularySishuTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


//- (void)testCreateVocabulary
//{
//    Vocabulary *newVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
//    newVocabulary.spell = @"apple";
//    newVocabulary.meet = [NSNumber numberWithInt:0];
//    __autoreleasing NSError *error = nil;
//    if (![[VSUtils currentMOContext] save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
//    STAssertEquals(@"apple", newVocabulary.spell, @"");
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDescription];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(spell=='apple')"];
//    [request setPredicate:predicate];
//    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
//    STAssertTrue([array count] == 1, @"Have one object");
//}

- (void)testNextList
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSString *predicateContent = [NSString stringWithFormat:@"(name=='GRE顺序List1')"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    VSList *list = [array objectAtIndex:0];
    
    VSList *nextList = [list nextList];
    STAssertNotNil(nextList, @"The next list is not nil");
    NSLog(@"%@", [VSUtils normalizeString:list.repository.name]);
    NSLog(@"%@", [VSUtils normalizeString:nextList.repository.name]);
//    STAssertTrue([nextList.repository.name isEqualToString:list.repository.name], @"Same repo");
    
}

@end
