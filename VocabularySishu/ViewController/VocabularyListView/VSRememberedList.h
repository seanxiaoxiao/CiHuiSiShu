//
//  VSRememberedList.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VSListVocabularyRecord;

@interface VSRememberedToken : NSObject

@property (nonatomic, assign) int index;

@property (nonatomic, retain) VSListVocabularyRecord *record;

@end

@interface VSRememberedList : NSObject

@property (nonatomic, retain) NSMutableArray *rememberedList;

- (void) addNewToken:(int )index withRecord:(VSListVocabularyRecord *)record;

- (VSRememberedToken *) popToken;

- (BOOL) isEmpty;

@end
