//
//  VSDataUtil.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSDataUtil.h"

NSMutableDictionary *repoMap;
NSMutableDictionary *vocabularyMap;

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
    NSDate *dateStarted = [[NSDate alloc] init];
   
    [VSDataUtil clearEntities:@"VSRepository"];
    repoMap = [[NSMutableDictionary alloc] init];
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
        repo.finishedRound = [NSNumber numberWithInt:0];
        [repoMap setValue:repo forKey:repo.name];
    }
    [VSUtils saveEntity];
    NSLog(@"Time elapse %f in import repo", [dateStarted timeIntervalSinceNow]);
}

+ (void)initRepoList
{
    [VSDataUtil clearEntities:@"VSList"];
    [VSDataUtil clearEntities:@"VSListVocabulary"];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Lists" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *datas = [parser objectWithString:jsonString];
    for (NSDictionary *data in datas) {
        VSRepository *repository = [repoMap objectForKey:[data objectForKey:@"repoName"]];
        VSList *list = [NSEntityDescription insertNewObjectForEntityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
        list.name = [data objectForKey:@"name"];
        list.order = [data objectForKey:@"order"];
        list.repository = repository;
        list.type = [VSConstant LIST_TYPE_NORMAL];
        list.status = [VSConstant LIST_STATUS_NEW];
        NSArray *vocabularies = [data objectForKey:@"vocabularyList"];
        for (int i = 0; i < [vocabularies count]; i++) {
            VSListVocabulary *listVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
            listVocabulary.vocabulary = [vocabularyMap objectForKey:[vocabularies objectAtIndex:i]];
            listVocabulary.list = list;
            listVocabulary.order = [NSNumber numberWithInt:i];
            listVocabulary.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
        }
    }
    [VSUtils saveEntity];
}

+ (void)initVocabularies
{
    vocabularyMap = [[NSMutableDictionary alloc] init];
    [VSDataUtil clearEntities:@"VSVocabulary"];
    NSDate *dateStarted = [[NSDate alloc] init];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"Vocabularies" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *vocabularies = [jsonString componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [vocabularies count]; i++) {
        NSDictionary *vocabularyInfo = [parser objectWithString:[vocabularies objectAtIndex:i]];
        VSVocabulary *vocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
        vocabulary.spell = [vocabularyInfo objectForKey:@"spell"];
        vocabulary.phonetic = [vocabularyInfo objectForKey:@"phonetic"];
        vocabulary.etymology = [vocabularyInfo objectForKey:@"etymology"];
        vocabulary.type = [vocabularyInfo objectForKey:@"type"];        
        vocabulary.audioLink = [vocabularyInfo objectForKey:@"audioLink"];
        vocabulary.summary = [vocabularyInfo objectForKey:@"summary"];
        NSLog(@"%@ with %@", vocabulary.spell, vocabulary.audioLink);
        vocabulary.meet = [NSNumber numberWithInt:0];
        vocabulary.forget = [NSNumber numberWithInt:0];
        vocabulary.remember = [NSNumber numberWithInt:0];
        [vocabularyMap setValue:vocabulary forKey:vocabulary.spell];
    }
    [VSUtils saveEntity];
    NSLog(@"Time elapse %f in import vocabulary", [dateStarted timeIntervalSinceNow]);
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
        }        
    }
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

+ (void)initData
{
    NSDate *dateStarted = [[NSDate alloc] init];
    [VSDataUtil clearEntities:@"VSContext"];
    [VSDataUtil initVocabularies];
    [VSDataUtil initRepoData];
    [VSDataUtil initRepoList];
    [VSDataUtil initMeanings];
    NSLog(@"Time elapse %f in import all", [dateStarted timeIntervalSinceNow]);

}


@end
