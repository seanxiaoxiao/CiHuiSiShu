//
//  VSVocabularyRecord.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyRecord.h"
#import "VSVocabulary.h"

@implementation VSVocabularyRecord

@dynamic meet;
@dynamic remember;
@dynamic spell;

- (void) initWithVocabulary:(VSVocabulary *)vocabulary
{
    self.meet = vocabulary.meet;
    self.remember = vocabulary.remember;
    self.spell = vocabulary.spell;
}

@end
