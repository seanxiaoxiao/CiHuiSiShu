//
//  VSDataUtil.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSDataUtil.h"
#import "VSListRecord.h"
#import "VSListVocabularyRecord.h"
#import "VSVocabularyRecord.h"
#import "VSAppRecord.h"

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
        NSLog(@"name is %@", repo.name);
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
            list.round = [NSNumber numberWithInt:0];
            NSArray *vocabularies = [data objectForKey:@"vocabularyList"];
            for (int i = 0; i < [vocabularies count]; i++) {
                VSVocabulary *vocabulary = [vocabularyMap objectForKey:[vocabularies objectAtIndex:i]];
                if (vocabulary == nil) {
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
        vocabulary.remember = [NSNumber numberWithInt:50];
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

+ (void)initMWMeanings1
{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"mw-1" ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *lines = [jsonString componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *dataString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:dataString];
        int order = 0;
        __autoreleasing VSVocabulary *vocabulary = [vocabularyMap objectForKey:spell];
        if (vocabulary == nil) {
            continue;
        }
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
    [VSUtils saveEntity];
    NSLog(@"Finish before saving 1");
}

+ (void)initMWMeanings2
{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"mw-2" ofType:@"txt"];
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    NSArray *lines = [jsonString componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *dataString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:dataString];
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
    [VSUtils saveEntity];
    NSLog(@"Finish before saving 2");
}

+ (void)initMWMeanings3
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"mw-3" ofType:@"txt"];
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *lines = [jsonString componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *dataString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:dataString];
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
    [VSUtils saveEntity];
    NSLog(@"Finish before saving 3");
}

+ (void)initMWMeanings4
{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"mw-4" ofType:@"txt"];
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    NSArray *lines = [jsonString componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *dataString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:dataString];
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

    [VSUtils saveEntity];
    NSLog(@"Finish before saving 4");
}

+ (void)initData
{
    NSLog(@"Finish init data");
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
    [VSDataUtil clearEntities:@"VSWebsterMeaning"];
    [VSDataUtil initFullMWMeanings];

    NSLog(@"Time elapse %f in import all", [dateStarted timeIntervalSinceNow]);

}

+ (void)initFullMWMeanings
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *repoData = [bundle pathForResource:@"WebsterMeaning" ofType:@"txt"];
    
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:repoData];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *lines = [jsonString componentsSeparatedByString:@"\n"];
    int count = 0;
    for (NSString *line in lines) {
        __autoreleasing NSArray *info = [line componentsSeparatedByString:@"\t"];
        __autoreleasing NSString *spell = [info objectAtIndex:0];
        __autoreleasing NSString *dataString = [info objectAtIndex:1];
        __autoreleasing NSArray *meaningArray = [parser objectWithString:dataString];
        int order = 0;
        __autoreleasing VSVocabulary *vocabulary = [vocabularyMap objectForKey:spell];
        if (vocabulary == nil) {
            continue;
        }
        count++;
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
    [VSUtils saveEntity];
    NSLog(@"%d saved", count);
}

+ (void)initMWMeaning
{
    vocabularyMap = [[NSMutableDictionary alloc] init];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSArray *list = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    for (VSVocabulary *vocabulary in list) {
        [vocabularyMap setValue:vocabulary forKey:vocabulary.spell];
    }
    //[VSDataUtil clearEntities:@"VSWebsterMeaning"];
    //[VSDataUtil initMWMeanings1];
    [VSDataUtil initMWMeanings2];
    //[VSDataUtil initMWMeanings3];
    //[VSDataUtil initMWMeanings4];
}

+ (void)testData
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *list = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    for (VSVocabulary *vocabulary in list) {
        NSLog(@"count for vocabulary %@ is %d", vocabulary.spell, [vocabulary.meanings count]);
    }
}

+ (void)migrateData
{
    NSArray* repos = [VSRepository allRepos];
    for (VSRepository *repo in repos) {
        repo.wordsTotal = [NSNumber numberWithInt:[repo wordsInRepo]];
        for (VSList *list in [repo lists]) {
            list.rememberCount = [NSNumber numberWithInt:0];
        }
    }
    [VSUtils saveEntity];
}

+ (void)fixData
{
    NSArray* repos = [VSRepository allRepos];
    for (VSRepository *repo in repos) {
        repo.wordsTotal = [NSNumber numberWithInt:[repo wordsInRepo]];
        for (VSList *list in [repo lists]) {
            if ([list.order intValue] == 35 && [list.repository.name isEqualToString:@"GRE分类"]) {
                list.name = @"错误";
                [VSUtils saveEntity];
            }
        }
    }
}

+ (void)readWriteMigrate
{
    [VSDataUtil clearEntities:@"VSListRecord"];
    [VSDataUtil clearEntities:@"VSVocabularyRecord"];
    [VSDataUtil clearEntities:@"VSListVocabularyRecord"];
    [VSDataUtil clearEntities:@"VSAppRecord"];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSList" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    NSArray *allList = [[[VSUtils currentMOContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:sortDescriptors];

    for (VSList *list in allList) {
        VSListRecord *listRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListRecord" inManagedObjectContext:[VSUtils currentMOContext]];
        [listRecord initWithVSList:list];
        NSArray *listVocabularies = [list allVocabularies];
        for (VSListVocabulary *listVocabulary in listVocabularies) {
            VSVocabulary *vocabulary = listVocabulary.vocabulary;
            VSVocabularyRecord *vocabularyRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
            [vocabularyRecord initWithVocabulary:vocabulary];
            VSListVocabularyRecord *listVocabularyRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
            [listVocabularyRecord initWithListVocabulary:listVocabulary];
            listVocabularyRecord.vocabularyRecord = vocabularyRecord;
            listVocabularyRecord.listRecord = listRecord;
        }
    }
    VSAppRecord *appRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSAppRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    appRecord.migrated = [NSNumber numberWithBool:YES];
    [VSUtils saveEntity];
}

@end
