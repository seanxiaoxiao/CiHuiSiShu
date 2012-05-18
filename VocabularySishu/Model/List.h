//
//  List.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/17/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSManagedObject *repository;
@property (nonatomic, retain) NSSet *listVocabularies;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addListVocabulariesObject:(NSManagedObject *)value;
- (void)removeListVocabulariesObject:(NSManagedObject *)value;
- (void)addListVocabularies:(NSSet *)values;
- (void)removeListVocabularies:(NSSet *)values;

@end
