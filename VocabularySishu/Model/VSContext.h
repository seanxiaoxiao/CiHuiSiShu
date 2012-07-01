//
//  VSContext.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VSUtils.h"
#import "VSConstant.h"

@class VSList, VSListVocabulary, VSRepository;

@interface VSContext : NSManagedObject

@property (nonatomic, retain) VSList *currentList;
@property (nonatomic, retain) VSListVocabulary *currentListVocabulary;
@property (nonatomic, retain) VSRepository *currentRepository;

+ (VSContext *)getContext;

+ (BOOL)isFirstTime;

- (void)fixCurrentList:(VSList *)list;

- (void)fixRepository:(VSRepository *)repo;

@end
