//
//  VSVocabulary.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabulary.h"
#import "VSMeaning.h"


@implementation VSVocabulary

@dynamic etymology;
@dynamic forget;
@dynamic meet;
@dynamic phonetic;
@dynamic remember;
@dynamic spell;
@dynamic meanings;
@dynamic websterMeanings;

- (void)remembered
{
    self.remember = [NSNumber numberWithInt:[self.remember intValue] + 1];
    self.meet = [NSNumber numberWithInt:[self.meet intValue] + 1];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)forgot
{
    self.forget = [NSNumber numberWithInt:[self.forget intValue] + 1];
    self.meet = [NSNumber numberWithInt:[self.meet intValue] + 1];
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
