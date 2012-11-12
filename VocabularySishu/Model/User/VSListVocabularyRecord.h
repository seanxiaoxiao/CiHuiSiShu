//
//  VSListVocabularyRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSListRecord, VSVocabularyRecord;
@class VSListVocabulary;

@interface VSListVocabularyRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * lastRememberStatus;
@property (nonatomic, retain) NSNumber * lastStatus;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) VSListRecord *listRecord;
@property (nonatomic, retain) VSVocabularyRecord *vocabularyRecord;

- (void)initWithListVocabulary:(VSListVocabulary *)listVocabulary;

@end
