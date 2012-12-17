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
#import "VSGuideViewController.h"

@class VSVocabulary;
@class VSListRecord;

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

+ (NSString *)getBundleName;

+ (NSString *)getBundleVersion;

+ (void)copySQLite;

+ (void)toNextList:(VSList *)currentList;

+ (void)toPreviousList:(VSList *)currentList;

+ (void)toGivenList:(VSList *)list;

+ (void)reloadCurrentList:(VSListRecord *)currentListRecord;

+ (void)showGuidPage;

+ (void)openSeries;

+ (NSString *)getUMengKey;

+ (NSNumber *)getAppId;

+ (NSString *)getBundleId;

+ (void)addBarronAndSelectedGRE;

@end
