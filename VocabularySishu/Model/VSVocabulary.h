//
//  VSVocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSMeaning;

@interface VSVocabulary : NSManagedObject

@property (nonatomic, retain) NSString * etymology;
@property (nonatomic, retain) NSNumber * forget;
@property (nonatomic, retain) NSNumber * meet;
@property (nonatomic, retain) NSString * phonetic;
@property (nonatomic, retain) NSNumber * remember;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSSet *meanings;
@property (nonatomic, retain) NSManagedObject *websterMeanings;

@end

@interface VSVocabulary (CoreDataGeneratedAccessors)

- (void)addMeaningsObject:(VSMeaning *)value;
- (void)removeMeaningsObject:(VSMeaning *)value;
- (void)addMeanings:(NSSet *)values;
- (void)removeMeanings:(NSSet *)values;
@end
