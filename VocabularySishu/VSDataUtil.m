//
//  VSDataUtil.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSDataUtil.h"

@implementation VSDataUtil

+ (void)clearEntities:(NSString *)entityName
{
    NSManagedObjectContext *context = [VSUtils currentMOContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (int i = 0; i < [array count]; i++) {
        id entity = [array objectAtIndex:i];
        [context deleteObject:entity];
    }
}

+ (void)initRepoData
{
    [VSDataUtil clearEntities:@"Repository"];

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
    [VSDataUtil clearEntities:@"List"];
    
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
        __autoreleasing NSError *error = nil;
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

+ (void)initVocabularies
{
    [VSDataUtil clearEntities:@"Vocabulary"];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Vocabularies" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *vocabularies = [parser objectWithString:jsonString];
    __autoreleasing NSError *error = nil;
    for (int i = 0; i < [vocabularies count]; i++) {
        NSDictionary *vocabularyInfo = [vocabularies objectAtIndex:i];
        Vocabulary *vocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
        vocabulary.spell = [vocabularyInfo objectForKey:@"spell"];
        vocabulary.phonetic = [vocabularyInfo objectForKey:@"phonetic"];
        vocabulary.etymology = [vocabularyInfo objectForKey:@"etymology"];
        vocabulary.meet = [NSNumber numberWithInt:0];
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

+ (void)initListVocabularies
{
    [VSDataUtil clearEntities:@"ListVocabulary"];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"ListVocabularies" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    __autoreleasing NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *repoVocabulariesDict = [parser objectWithString:jsonString];
    NSArray *repoListKeys = [repoVocabulariesDict allKeys];
    for (NSString *key in repoListKeys) {
        NSEntityDescription *repoDescription = [NSEntityDescription entityForName:@"List" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *repoRequest = [[NSFetchRequest alloc] init];
        [repoRequest setEntity:repoDescription];
        NSString *repoPredicateContent = [NSString stringWithFormat:@"(name=='%@')", key];
        NSPredicate *repoPredicate = [NSPredicate predicateWithFormat: repoPredicateContent];
        [repoRequest setPredicate:repoPredicate];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:repoRequest error:&error];
        List *list = [array objectAtIndex:0];
        NSArray *vocabularies = [repoVocabulariesDict objectForKey:key];
        for (int i = 0; i < [vocabularies count]; i++) {
            NSString *spell = [vocabularies objectAtIndex:i];
            NSEntityDescription *vocabularyDescription = [NSEntityDescription entityForName:@"Vocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
            NSFetchRequest *vocabularyRequest = [[NSFetchRequest alloc] init];
            [vocabularyRequest setEntity:vocabularyDescription];
            NSString *vocabularyPredicateContent = [NSString stringWithFormat:@"(spell=='%@')", spell];
            NSPredicate *vocabularyPredicate = [NSPredicate predicateWithFormat:vocabularyPredicateContent];
            [vocabularyRequest setPredicate:vocabularyPredicate];
            NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:vocabularyRequest error:&error];
            Vocabulary *vocabulary = [results objectAtIndex:0];
            
            ListVocabulary *listVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"ListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
            listVocabulary.vocabulary = vocabulary;
            listVocabulary.list = list;
            if (![[VSUtils currentMOContext] save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}

+ (void)initData
{
    //[VSDataUtil initRepoData];
    //[VSDataUtil initRepoList];
    //[VSDataUtil initVocabularies];
    //[VSDataUtil initListVocabularies];
}


@end
