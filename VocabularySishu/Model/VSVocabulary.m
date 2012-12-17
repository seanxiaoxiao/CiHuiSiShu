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

+ (NSArray *)allRecords
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabulary" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    return [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
}

- (UIImage *)vocabularyImage
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.spell withExtension: @"jpg"];
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

- (VSVocabularyRecord *)getVocabularyRecord
{
    NSError *error = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSVocabularyRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(spell = %@)", self.spell];
    [request setPredicate:predicate];
    [request setEntity:entityDescription];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    return [results objectAtIndex:0];
}


@end
