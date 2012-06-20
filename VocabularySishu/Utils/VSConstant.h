//
//  VSConstant.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/22/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MEANINGTEMPLATE @"<div id='meaning'><ul>%@</ul></div>"

#define MEANINGLINETEMPLATE @"<li><div>%@</div><div>%@</div></li>"

#define VOCABULARY_LIST_STATUS_REMEMBERED 1
#define VOCABULARY_LIST_STATUS_NEW 0
#define VOCABULARY_LIST_STATUS_FORGOT 2

#define FINISH_LOADING_MEANING_NOTIFICATION @"finish_loading_meaning_notification"


@interface VSConstant : NSObject

+ (NSNumber *)LIST_STATUS_NEW;

+ (NSNumber *)LIST_STATUS_PROCESSING;

+ (NSNumber *)LIST_STATUS_FINISH;

@end
