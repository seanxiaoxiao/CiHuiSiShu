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

@synthesize seeSummaryStart;
@synthesize seeSummaryTimes;
@synthesize cacheVocabulary;

- (void) initWithVocabulary:(VSVocabulary *)vocabulary
{
    self.meet = vocabulary.meet;
    self.remember = vocabulary.remember;
    self.spell = vocabulary.spell;
}

- (VSVocabulary *)getVocabulary
{
    if (cacheVocabulary == nil) {
        NSError *error = nil;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(spell = %@)", self.spell];
        [request setPredicate:predicate];
        [request setEntity:entityDescription];
        NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        cacheVocabulary = [results objectAtIndex:0];
    }
    return cacheVocabulary;
}

- (void)remembered
{
    int incr = 15;
    self.remember = [NSNumber numberWithInt:[self.remember intValue] + incr];
    if ([self.remember intValue] > 100) {
        self.remember = [NSNumber numberWithInt:100];
    }
    self.meet = [NSNumber numberWithInt:[self.meet intValue] + 1];
    [VSUtils saveEntity];
}

- (void)forgot
{
    int meet = [self.meet intValue];
    int decr = 0;
    if (meet < 2) {
        decr = 40;
    }
    else if (meet < 5) {
        decr = 30;
    }
    else {
        decr = 10;
    }

    self.remember = [NSNumber numberWithDouble:[self.remember doubleValue] - decr];
    if ([self.remember intValue] < 0) {
        self.remember = [NSNumber numberWithInt:0];
    }
    [VSUtils saveEntity];
    self.seeSummaryTimes += 1;
    self.seeSummaryStart = [[NSDate alloc] init];
}

- (void)finishSummary
{
}

- (BOOL)rememberNotWell
{
    return [self.meet integerValue] > 0 && [self.remember doubleValue] >= 30 && [self.remember doubleValue] < 65;
}

- (BOOL)rememberBad
{
    return [self.meet integerValue] > 0 && [self.remember doubleValue] <= 30;
}

- (void)seeSummary
{
    self.seeSummaryStart = [[NSDate alloc] init];
}

- (BOOL)rememberWell
{
    return [self.remember intValue] >= 65;
}


@end
