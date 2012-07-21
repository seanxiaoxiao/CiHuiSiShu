//
//  VSWebsterMeaning.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSVocabulary;

@interface VSWebsterMeaning : NSManagedObject

@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * meaning;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) VSVocabulary *vocabulary;

@end
