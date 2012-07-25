//
//  VSUtils.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSContext.h"
#import "VSVocabulary.h"
#import "VSList.h"

@class VSVocabulary;

@interface VSUtils : NSObject

+ (NSManagedObjectContext *)currentMOContext;

+ (void)saveEntity;

+ (UIImage *)fetchImg:(NSString *)imageName;

+ (NSManagedObject *)get:(NSManagedObjectID *)moID;

+ (NSDate *)getToday;

+ (BOOL) vocabularySame:(VSVocabulary *)first with:(VSVocabulary *)second;

+ (NSString *)normalizeString:(NSString *)source;

+ (NSDate *)converToNormalDate:(NSDate *)date;

+ (NSDate *)getNow;

+ (void)copySQLite;

+ (void)toNextList:(VSList *)currentList;

+ (void)toPreviousList:(VSList *)currentList;

@end
