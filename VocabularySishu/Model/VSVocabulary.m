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
@dynamic lastSeeDate;
@synthesize seeSummaryStart;
@synthesize seeSummaryTimes;

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
    NSLog(@"Remember %@, meet %@, incr is %f, now remember is %@", self.meet, self.spell, incr, self.remember);
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
    NSLog(@"Forget %@, meet %@, decr is %f, now remember is %@", self.meet, self.spell, decr, self.remember);
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
    NSLog(@"Finish Summary %@, meet %@, decr is %f, now remember is %@", self.meet, self.spell, decr, self.remember);
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


- (UIImage *)vocabularyImage
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.spell withExtension: @"jpg"];
    NSLog(@"%@", url);
    return url != nil ? [UIImage imageWithData:[NSData dataWithContentsOfURL:url]] : nil;
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

- (NSURL *)audioURL
{
    NSRange r;
    r.location = 0;
    r.length = 1;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@.mp3", VSS_RESOURCE_SERVICE, [[self.spell substringWithRange:r] lowercaseString], [self.spell stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    return [NSURL URLWithString:urlString];
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
