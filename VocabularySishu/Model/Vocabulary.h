//
//  Vocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vocabulary : NSManagedObject

@property (nonatomic, retain) NSString * etymology;
@property (nonatomic, retain) NSNumber * meet;
@property (nonatomic, retain) NSString * phonetic;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSSet *meanings;
@end

@interface Vocabulary (CoreDataGeneratedAccessors)

- (void)addMeaningsObject:(NSManagedObject *)value;
- (void)removeMeaningsObject:(NSManagedObject *)value;
- (void)addMeanings:(NSSet *)values;
- (void)removeMeanings:(NSSet *)values;

@end
