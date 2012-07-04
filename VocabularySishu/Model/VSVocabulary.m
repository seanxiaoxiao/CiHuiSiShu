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
@dynamic type;
@dynamic audioLink;

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

- (NSString *)meetTimes
{
    return [self.meet description];
}

- (NSString *)rememberedTimes
{
    return [self.remember description];
}

- (NSString *)forgotTimes
{
    return [self.forget description];
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

@end
