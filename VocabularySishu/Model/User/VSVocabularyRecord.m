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
    double meet = [self.meet doubleValue];
    double incr = 12 * pow(M_E, meet / (meet + 6));
    self.remember = [NSNumber numberWithDouble:[self.remember doubleValue] + incr];
    if ([self.remember doubleValue] > 100) {
        self.remember = [NSNumber numberWithDouble:100];
    }
    self.meet = [NSNumber numberWithInt:[self.meet intValue] + 1];
    [VSUtils saveEntity];
}

- (void)forgot
{
    double meet = [self.meet doubleValue];
    double decr = 40 * pow(M_E, (-3 * meet) / (meet + 1) - 3 * self.seeSummaryTimes);
    self.remember = [NSNumber numberWithDouble:[self.remember doubleValue] - decr];
    if ([self.remember doubleValue] < 0) {
        self.remember = [NSNumber numberWithDouble:0];
    }
    [VSUtils saveEntity];
    self.seeSummaryTimes += 1;
    self.seeSummaryStart = [[NSDate alloc] init];
}

- (void)finishSummary
{
    NSTimeInterval elapse = -[self.seeSummaryStart timeIntervalSinceNow];
    double decr = 4 / self.seeSummaryTimes * pow(M_E, elapse / 10);
    self.remember = [NSNumber numberWithDouble:[self.remember doubleValue] - decr];
    if ([self.remember doubleValue] < 0) {
        self.remember = [NSNumber numberWithDouble:0];
    }
    [VSUtils saveEntity];
}

- (void)seeSummary
{
    self.seeSummaryStart = [[NSDate alloc] init];
}

- (BOOL)rememberWell
{
    return [self.remember intValue] > 60;
}


@end
