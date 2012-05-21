//
//  ListVocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List, Vocabulary;

@interface ListVocabulary : NSManagedObject

@property (nonatomic, retain) List *list;
@property (nonatomic, retain) Vocabulary *vocabulary;

@end
