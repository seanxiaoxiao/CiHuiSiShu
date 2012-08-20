//
//  VSListVocabulary.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSListVocabulary.h"
#import "VSList.h"
#import "VSVocabulary.h"
#import "VSConstant.h"


@implementation VSListVocabulary

@dynamic lastStatus;
@dynamic order;
@dynamic list;
@dynamic vocabulary;
@dynamic lastRememberStatus;

+ (void)create:(VSList *)theList withVocabulary:(VSVocabulary *)theVocabulary
{
    int newOrder = [theList.listVocabularies count];
    VSListVocabulary *newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSListVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    newRecord.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_NEW];
    newRecord.order = [NSNumber numberWithInt:newOrder];
    newRecord.list = theList;
    newRecord.vocabulary = theVocabulary;
    if ([theList isHistoryList]) {
        newRecord.lastRememberStatus = [theVocabulary rememberWell] ? [VSConstant REMEMBER_STATUS_GOOD] : [VSConstant REMEMBER_STATUS_BAD];
    }
    [VSUtils saveEntity];
}

- (void)remembered
{
    self.lastStatus = [VSConstant VOCABULARY_LIST_STATUS_REMEMBERED];

    self.lastRememberStatus = [self.vocabulary rememberWell] ? [VSConstant REMEMBER_STATUS_GOOD] : [VSConstant REMEMBER_STATUS_BAD];
    if ([self.lastRememberStatus isEqualToNumber:[VSConstant REMEMBER_STATUS_GOOD]]) {
        self.list.rememberCount = [NSNumber numberWithInt:([self.list.rememberCount integerValue] + 1)];
    }
    [VSUtils saveEntity];
}



@end
