//
//  VSListVocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSList, VSVocabulary;

@interface VSListVocabulary : NSManagedObject

@property (nonatomic, retain) NSNumber * lastStatus;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * lastRememberStatus;
@property (nonatomic, retain) VSList *list;
@property (nonatomic, retain) VSVocabulary *vocabulary;
@property (nonatomic, assign) BOOL dragged;

+ (void)create:(VSList *)theList withVocabulary:(VSVocabulary *)theVocabulary;

- (void)remembered;

- (void)forgot;

@end
