//
//  List.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repository;

@interface List : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet *listVocabularies;
@property (nonatomic, retain) Repository *repository;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addListVocabulariesObject:(NSManagedObject *)value;
- (void)removeListVocabulariesObject:(NSManagedObject *)value;
- (void)addListVocabularies:(NSSet *)values;
- (void)removeListVocabularies:(NSSet *)values;

@end
