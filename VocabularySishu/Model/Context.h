//
//  Context.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSUtils.h"

@class List, ListVocabulary, Repository;

@interface Context : NSManagedObject

@property (nonatomic, retain) List *currentList;
@property (nonatomic, retain) Repository *currentRepository;
@property (nonatomic, retain) ListVocabulary *currentListVocabulary;

- (List *) fetchCurrentList;


@end
