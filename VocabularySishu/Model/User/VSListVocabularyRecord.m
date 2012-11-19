//
//  VSListVocabularyRecord.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSListVocabularyRecord.h"
#import "VSListRecord.h"
#import "VSVocabularyRecord.h"
#import "VSListVocabulary.h"

@implementation VSListVocabularyRecord

@dynamic lastRememberStatus;
@dynamic lastStatus;
@dynamic order;
@dynamic listRecord;
@dynamic vocabularyRecord;

- (void)initWithListVocabulary:(VSListVocabulary *)listVocabulary
{
    self.lastRememberStatus = listVocabulary.lastRememberStatus;
    self.lastStatus = listVocabulary.lastStatus;
    self.order = listVocabulary.order;
}

- (void)remembered
{
    self.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_REMEMBERED];
    
    self.lastRememberStatus = [self.vocabularyRecord rememberWell] ? [VSConstant REMEMBER_STATUS_GOOD] : [VSConstant REMEMBER_STATUS_BAD];
    if ([self.lastRememberStatus isEqualToNumber:[VSConstant REMEMBER_STATUS_GOOD]]) {
        self.listRecord.rememberCount = [NSNumber numberWithInt:([self.listRecord.rememberCount integerValue] + 1)];
    }
    [VSUtils saveEntity];
}


+ (void)create:(VSListRecord *)theList withVocabulary:(VSVocabularyRecord *)theVocabulary
{
    int newOrder = [theList.listVocabularies count];
    VSListVocabularyRecord *newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    newRecord.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
    newRecord.order = [NSNumber numberWithInt:newOrder];
    newRecord.listRecord = theList;
    newRecord.vocabularyRecord = theVocabulary;
    if ([theList isHistoryList]) {
        newRecord.lastRememberStatus = [theVocabulary rememberWell] ? [VSConstant REMEMBER_STATUS_GOOD] : [VSConstant REMEMBER_STATUS_BAD];
    }
    [VSUtils saveEntity];
}



@end
