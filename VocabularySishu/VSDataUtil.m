//
//  VSDataUtil.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSDataUtil.h"
#import "DDFileReader.h"

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
    NSString *contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *contentArray = [contentString componentsSeparatedByString:@"\n"];
    for (NSString *jsonString in contentArray) {
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
                VSVocabulary *vocabulary = [vocabularyMap objectForKey:[vocabularies objectAtIndex:i]];
                if (vocabulary == nil) {
                    NSLog(@"Nil at %@", contentString);
                    NSLog(@"Nil for %@", [vocabularies objectAtIndex:i]);
                    continue;
                }
                VSListVocabulary *listVocabulary = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
                listVocabulary.vocabulary = [vocabularyMap objectForKey:[vocabularies objectAtIndex:i]];
                listVocabulary.list = list;
                listVocabulary.order = [NSNumber numberWithInt:i];
                listVocabulary.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
            }
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
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    for (NSString *line in lines) {
        NSArray *info = [line componentsSeparatedByString:@"::"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        NSString *jsonString = [info objectAtIndex:1];
        NSArray *meaningArray = [parser objectWithString:jsonString];
        int order = 0;
        VSVocabulary *vocabulary = [vocabularyMap objectForKey:spell];
        if (vocabulary == nil) {
            continue;
        }
        for (NSDictionary *meaningInfo in meaningArray) {
            __autoreleasing NSString *attr = [meaningInfo objectForKey:@"attribute"];
            __autoreleasing NSString *meaningContent = [meaningInfo objectForKey:@"meaning"];
            if ([attr length] == 0 || [meaningContent length] == 0) {
                continue;
            }
            VSMeaning *meaning = [NSEntityDescription insertNewObjectForEntityForName:@"VSMeaning" inManagedObjectContext:[VSUtils currentMOContext]];
            meaning.vocabulary = vocabulary;
            meaning.attribute = attr;
            meaning.meaning = meaningContent;
            meaning.order = [NSNumber numberWithInt:order];
            order = order + 1;
        }
    }
    [VSUtils saveEntity];
}

+ (void)initMWMeanings
{
    [VSDataUtil clearEntities:@"VSWebsterMeaning"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"WebsterMeaning" ofType:@"txt"];
    
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:repoData];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *line = nil;
    while ((line = [reader readLine])) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *jsonString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:jsonString];
        int order = 0;
        __autoreleasing VSVocabulary *vocabulary = [vocabularyMap objectForKey:spell];
        if (vocabulary == nil) {
            continue;
        }
        NSLog(@"%@", [info objectAtIndex:0]);
        for (NSDictionary *meaningInfo in meaningArray) {
            __autoreleasing NSString *attr = [meaningInfo objectForKey:@"attribute"];
            __autoreleasing NSString *meaningContent = [meaningInfo objectForKey:@"meaning"];
            if ([attr length] == 0 || [meaningContent length] == 0) {
                continue;
            }
            VSWebsterMeaning *meaning = [NSEntityDescription insertNewObjectForEntityForName:@"VSWebsterMeaning" inManagedObjectContext:[VSUtils currentMOContext]];
            meaning.vocabulary = vocabulary;
            meaning.attribute = attr;
            meaning.meaning = meaningContent;
            meaning.order = [NSNumber numberWithInt:order];
            order = order + 1;
        }
    }
    reader = nil;
    [VSUtils saveEntity];
    NSLog(@"Finish before saving");
}

+ (void)initData
{
    NSDate *dateStarted = [[NSDate alloc] init];
    [VSDataUtil clearEntities:@"VSContext"];
    NSLog(@"Vocabulary");
    [VSDataUtil initVocabularies];
    NSLog(@"Repo");
    [VSDataUtil initRepoData];
    NSLog(@"RepoList");
    [VSDataUtil initRepoList];
    NSLog(@"Meaning");
    [VSDataUtil initMeanings];
    NSLog(@"MWMeaning");
    [VSDataUtil initMWMeanings];

    NSLog(@"Time elapse %f in import all", [dateStarted timeIntervalSinceNow]);

}


@end
