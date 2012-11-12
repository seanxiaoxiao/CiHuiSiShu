//
//  VSVocabularyRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSVocabulary;

@interface VSVocabularyRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * meet;
@property (nonatomic, retain) NSNumber * remember;
@property (nonatomic, retain) NSString * spell;

- (void) initWithVocabulary:(VSVocabulary *)vocabulary;

@end
