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
#define CLEAR_VOCABULRY @"clear_vocabulary"
#define PLAY_VOCABULARY @"play_vocabulary"
#define RESTART_LIST @"restart_list"
#define NEXT_LIST @"next_list"
#define HIDE_SCOREBOARD @"hide_scoreboard"
#define CLOSE_POPUP @"close_popup"
#define SET_PLAN_FINISH_DATE @"set_plan_finish_date"
#define SHOW_PICKER @"show_picker"

#define SHORTTERM_REVIEW_INTERVAL 8 * 60 * 60;
#define LONGTERM_REVIEW_INTERVAL 1 * 24 * 60 * 60;
#define LONGTERM_EXPIRE_INTERVAL 18 * 60 * 60;
#define SHORTTERM_EXPIRE_INTERVAL 5 * 60 * 60;
#define NOTIFICATION_DENY 60 * 60;
#define VSS_RESOURCE_SERVICE @"http://www.gefostudio.com/vss/audio"

#define EVENT_ENTER_HISTORY @"ENTER_HISTORY"
#define EVENT_ENTER_LIST @"ENTER_LIST"
#define EVENT_SELECT_REPO @"SELECT_REPO"
#define EVENT_SELECT_LIST @"SELECT_LIST"
#define EVENT_REMEMBER @"REMEMBER"
#define EVENT_FORGET @"FORGET"
#define EVENT_SHOW_SCORE @"SHOW_SCORE"
#define EVENT_RETRY @"RETRY"
#define EVENT_NEXT_LIST @"NEXT_LIST"
#define EVENT_ENTER_DETAIL @"ENTER_DETAIL"
#define EVENT_SET_FINISH_PLAN @"SET_FINISH_PLAN"
#define EVENT_REVERT_TOKEN @"REVERT_TOKEN"
#define EVENT_WANT_TO_BUY @"WANT_TO_BUY"

#ifdef TRIAL
    #define HISTORY_ITEM_COUNT 3
#else
    #define HISTORY_ITEM_COUNT 4
#endif

#define VOCAVULARY_CELL_HEIGHT 56

@interface VSConstant : NSObject

+ (NSNumber *)LIST_STATUS_NEW;

+ (NSNumber *)LIST_STATUS_PROCESSING;

+ (NSNumber *)LIST_STATUS_FINISH;

+ (NSNumber *)VOCABULARY_LIST_STATUS_NEW;

+ (NSNumber *)VOCABULARY_LIST_STATUS_REMEMBERED;

+ (NSNumber *)VOCABULARY_LIST_STATUS_FORGOT;

+ (NSNumber *)LIST_TYPE_NORMAL;

+ (NSNumber *)LIST_TYPE_HISTORY;

+ (NSNumber *)LIST_TYPE_SHORTTERM_REVIEW;

+ (NSNumber *)LIST_TYPE_LONGTERM_REVIEW;

+ (NSNumber *)REMEMBER_STATUS_BAD;

+ (NSNumber *)REMEMBER_STATUS_GOOD;

@end
