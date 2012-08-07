//
//  VSDataUtil.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SBJSON.h"
#import "SBJsonParser.h"
#import "VSUtils.h"
#import "VSRepository.h"
#import "VSList.h"
#import "VSVocabulary.h"
#import "VSListVocabulary.h"
#import "VSMeaning.h"
#import "VSConstant.h"
#import "VSWebsterMeaning.h"

@interface VSDataUtil : NSObject

+ (void)initData;

+ (void)testData;

+ (void)initMWMeaning;

+ (void)initFullMWMeanings;
@end
