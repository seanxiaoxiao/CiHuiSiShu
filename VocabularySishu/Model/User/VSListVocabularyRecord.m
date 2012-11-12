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

@end
