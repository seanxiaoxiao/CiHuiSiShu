//
//  VSVocabulary.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabulary.h"
#import "VSMeaning.h"
#import <math.h>

@implementation VSVocabulary

@dynamic etymology;
@dynamic meet;
@dynamic phonetic;
@dynamic remember;
@dynamic spell;
@dynamic meanings;
@dynamic websterMeanings;
@dynamic type;
@dynamic summary;
@dynamic audioLink;
@synthesize seeSummaryStart;
@synthesize seeSummaryTimes;

- (void)remembered
{
    double meet = [self.meet doubleValue];
    double incr = 10 * pow(M_E, meet / (meet + 6));
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
    double decr = 60 * pow(M_E, (-3 * meet) / (meet + 1) - 3 * self.seeSummaryTimes);
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
    double decr = 8 / self.seeSummaryTimes * pow(M_E, elapse / 10);
    self.remember = [NSNumber numberWithDouble:[self.remember doubleValue] - decr];
    if ([self.remember doubleValue] < 0) {
        self.remember = [NSNumber numberWithDouble:0];
    }
    [VSUtils saveEntity];
}

- (NSString *)meetTimes
{
    return [self.meet description];
}

- (NSString *)rememberedTimes
{
    return [self.remember description];
}

- (BOOL)cannotRememberWell
{
    return [self.meet intValue] > 0 && [[self rememberRate] floatValue] <= 0.79;
}

- (NSDecimalNumber *)rememberRate
{
    if ([self.meet intValue] == 0) {
        return [[NSDecimalNumber alloc] initWithFloat:0];
    }
    else {
        return [[NSDecimalNumber alloc] initWithFloat:([self.remember floatValue]/ [self.meet floatValue])];
    }
}

- (UIImage *)vocabularyImage
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.spell withExtension: @"jpg"];
    NSLog(@"%@", url);
    return url != nil ? [UIImage imageWithData:[NSData dataWithContentsOfURL:url]] : nil;
}

- (BOOL)hasAudioLink
{
    return self.audioLink != nil && [self.audioLink length] > 0;
}

- (NSArray *)orderedMeanings
{
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[self.meanings allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray *)orderedWMMeanings
{
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[self.websterMeanings allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSArray *)allVocabularies
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    return [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
}

@end
