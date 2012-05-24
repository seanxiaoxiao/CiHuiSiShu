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
    [VSDataUtil clearEntities:@"VSRepository"];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Repos" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *repoArray = [parser objectWithString:jsonString];
    for (int i = 0; i < [repoArray count]; i++) {
        VSRepository *repo = [NSEntityDescription insertNewObjectForEntityForName:@"VSRepository" inManagedObjectContext:[VSUtils currentMOContext]];
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
    [VSDataUtil clearEntities:@"VSList"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Lists" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *repoListDict = [parser objectWithString:jsonString];
    NSArray *repoListKeys = [repoListDict allKeys];
    __autoreleasing NSError *error = nil;
    for (NSString *key in repoListKeys) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSRepository" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSString *predicateContent = [NSString stringWithFormat:@"(name=='%@')", key];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
        [request setPredicate:predicate];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        VSRepository *repository = [array objectAtIndex:0];
        NSArray *repoLists = [repoListDict objectForKey:key];
        for (int i = 0; i < [repoLists count]; i++) {
            VSList *list = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
            list.name = [repoLists objectAtIndex:i];
            list.order = [NSNumber numberWithInt:i];
            list.repository = repository;
            list.isHistory = NO;
            __autoreleasing NSError *error = nil;
            if (![[VSUtils currentMOContext] save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}

+ (void)initVocabularies
{
    [VSDataUtil clearEntities:@"VSVocabulary"];

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
        VSVocabulary *vocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
        vocabulary.spell = [vocabularyInfo objectForKey:@"spell"];
        vocabulary.phonetic = [vocabularyInfo objectForKey:@"phonetic"];
        vocabulary.etymology = [vocabularyInfo objectForKey:@"etymology"];
        vocabulary.meet = [NSNumber numberWithInt:0];
        vocabulary.forget = [NSNumber numberWithInt:0];
        vocabulary.remember = [NSNumber numberWithInt:0];
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

+ (void)initListVocabularies
{
    [VSDataUtil clearEntities:@"VSListVocabulary"];

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
        NSEntityDescription *repoDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *repoRequest = [[NSFetchRequest alloc] init];
        [repoRequest setEntity:repoDescription];
        NSString *repoPredicateContent = [NSString stringWithFormat:@"(name=='%@')", key];
        NSPredicate *repoPredicate = [NSPredicate predicateWithFormat: repoPredicateContent];
        [repoRequest setPredicate:repoPredicate];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:repoRequest error:&error];
        VSList *list = [array objectAtIndex:0];
        NSArray *vocabularies = [repoVocabulariesDict objectForKey:key];
        for (int i = 0; i < [vocabularies count]; i++) {
            NSString *spell = [vocabularies objectAtIndex:i];
            NSEntityDescription *vocabularyDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
            NSFetchRequest *vocabularyRequest = [[NSFetchRequest alloc] init];
            [vocabularyRequest setEntity:vocabularyDescription];
            NSString *vocabularyPredicateContent = [NSString stringWithFormat:@"(spell=='%@')", spell];
            NSPredicate *vocabularyPredicate = [NSPredicate predicateWithFormat:vocabularyPredicateContent];
            [vocabularyRequest setPredicate:vocabularyPredicate];
            NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:vocabularyRequest error:&error];
            VSVocabulary *vocabulary = [results objectAtIndex:0];
            
            VSListVocabulary *listVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
            listVocabulary.vocabulary = vocabulary;
            listVocabulary.list = list;
            listVocabulary.lastStatus = VOCABULARY_LIST_STATUS_NEW;
            if (![[VSUtils currentMOContext] save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}

+ (void)initMeanings
{
    [VSDataUtil clearEntities:@"VSMeaning"];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Meaning" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    __autoreleasing NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *meaningDict = [parser objectWithString:jsonString];
    NSArray *meaningKeys = [meaningDict allKeys];
    for (NSString *key in meaningKeys) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSString *predicateContent = [NSString stringWithFormat:@"(spell=='%@')", key];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateContent];
        [request setPredicate:predicate];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        VSVocabulary *vocabulary = [array objectAtIndex:0];
        
        NSArray *meanings = [meaningDict objectForKey:key];
        for (int i = 0; i < [meanings count]; i++) {
            NSDictionary *meaningInfo = [meanings objectAtIndex:i];
            VSMeaning *meaning = [NSEntityDescription insertNewObjectForEntityForName:@"VSMeaning" inManagedObjectContext:[VSUtils currentMOContext]];
            meaning.vocabulary = vocabulary;
            meaning.attribute = [meaningInfo objectForKey:@"attribute"];
            meaning.meaning = [meaningInfo objectForKey:@"meaning"];
            if (![[VSUtils currentMOContext] save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}

+ (void)initData
{
    [VSDataUtil initRepoData];
    [VSDataUtil initRepoList];
    [VSDataUtil initVocabularies];
    [VSDataUtil initListVocabularies];
    [VSDataUtil initMeanings];
}


@end
