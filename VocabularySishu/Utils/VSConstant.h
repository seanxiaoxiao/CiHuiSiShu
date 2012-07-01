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

#define FINISH_LOADING_MEANING_NOTIFICATION @"finish_loading_meaning_notification"
#define SHOW_DETAIL_VIEW @"show_detail_view"

#define SHOW_TORECITE @"show_torecite"
#define SHOW_CANNOTREMEMBERWELL @"show_cannotrememberwell"
#define SHOW_OFTENFORGET @"show_oftenforget"
#define SHOW_EASYTOFORGET @"show_easytoforget"
#define SHOW_ALL @"show_all"

@interface VSConstant : NSObject

+ (NSNumber *)LIST_STATUS_NEW;

+ (NSNumber *)LIST_STATUS_PROCESSING;

+ (NSNumber *)LIST_STATUS_FINISH;

+ (NSNumber *)VOCABULARY_LIST_STATUS_NEW;

+ (NSNumber *)VOCABULARY_LIST_STATUS_REMEMBERED;

+ (NSNumber *)VOCABULARY_LIST_STATUS_FORGOT;

@end
