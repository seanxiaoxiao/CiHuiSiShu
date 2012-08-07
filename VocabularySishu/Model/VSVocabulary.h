//
//  VSVocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSUtils.h"

@class VSMeaning;
@class VSWebsterMeaning;

@interface VSVocabulary : NSManagedObject

@property (nonatomic, retain) NSString * etymology;
@property (nonatomic, retain) NSNumber * meet;
@property (nonatomic, retain) NSString * phonetic;
@property (nonatomic, retain) NSNumber * remember;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * audioLink;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSSet *meanings;
@property (nonatomic, retain) NSSet *websterMeanings;
@property (nonatomic, retain) NSDate *seeSummaryStart;
@property (nonatomic, retain) NSDate *lastSeeDate;
@property (nonatomic, assign) int seeSummaryTimes;

- (void)remembered;

- (void)forgot;

- (void)finishSummary;

- (void)seeSummary;

- (void)play;

- (NSString *)forgotTimes;

- (NSDecimalNumber *)rememberRate;

- (UIImage *)vocabularyImage;

- (BOOL)cannotRememberWell;

- (BOOL)hasAudioLink;

- (NSArray *)orderedMeanings;

- (NSArray *)orderedWMMeanings;

+ (NSArray *)allVocabularies;

@end

@interface VSVocabulary (CoreDataGeneratedAccessors)

- (void)addMeaningsObject:(VSMeaning *)value;
- (void)removeMeaningsObject:(VSMeaning *)value;
- (void)addMeanings:(NSSet *)values;
- (void)removeMeanings:(NSSet *)values;

- (void)addWebsterMeaningsObject:(VSWebsterMeaning *)value;
- (void)removeWebsterMeaningsObject:(VSWebsterMeaning *)value;
- (void)addWebsterMeanings:(NSSet *)values;
- (void)removeWebsterMeanings:(NSSet *)values;

@end
