//
//  VSReviewPlan.m
//  VocabularySishu
//
//  Created by xiao xiao on 7/1/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSReviewPlan.h"

static VSReviewPlan *PLAN;

@implementation VSReviewPlan

@synthesize shortTermList;
@synthesize longTermList;

+ (VSReviewPlan *)getPlan
{
    if (PLAN == nil) {
        PLAN = [[VSReviewPlan alloc] init];
    }
    return PLAN;
}

- (void)rememberVocabulary:(VSVocabulary *)vocabulary;
{
    [self initReviewList];
    if (![vocabulary rememberWell]) {
        [shortTermList addVocabulary:vocabulary];
    }
    else {
        [longTermList addVocabulary:vocabulary];
    }
}

- (void)forgetVocabulary:(VSVocabulary *)vocabulary
{
    [self initReviewList];
    if ([vocabulary rememberWell]) {
        [shortTermList addVocabulary:vocabulary];
    }
}


- (void)initReviewList
{
    shortTermList = [VSList latestShortTermReviewList];
    longTermList = [VSList latestLongTermReviewList];
    if (shortTermList == nil) {
        NSLog(@"No short list");
        shortTermList = [VSList createAndGetShortTermReviewList];
    }
    if (longTermList == nil) {
        NSLog(@"No long list");
        longTermList = [VSList createAndGetLongTermReviewList];
    }
    if ([shortTermList shortTermExpire]) {
        NSLog(@"Short List expire");
        [self fireShortTermNotification];
        shortTermList = [VSList createAndGetShortTermReviewList];
    }
    if ([longTermList longTermExpire]) {
        NSLog(@"Long List expire");
        [self fireLongTermNotification];
        longTermList = [VSList createAndGetLongTermReviewList];
    }
}

- (void)fireShortTermNotification
{
    if ([self.shortTermList.listVocabularies count] == 0) {
        return;
    }
    UILocalNotification *notification=[[UILocalNotification alloc] init]; 
    if (notification != nil) {
        NSDate *now = [[NSDate alloc] init];
        NSTimeInterval interval = SHORTTERM_REVIEW_INTERVAL;
        notification.fireDate = [now dateByAddingTimeInterval:interval];
        NSLog(@"Fire at %@", notification.fireDate);
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"上次背诵中，你有些单词记得不是特别熟，老师建议你稍微再看下";
        NSDictionary *data = [NSDictionary dictionaryWithObject:[[[self.shortTermList objectID] URIRepresentation] absoluteString] forKey:@"list_id"];
        notification.userInfo = data;
        NSLog(@"Fire");
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)fireLongTermNotification
{
    if ([self.longTermList.listVocabularies count] == 0) {
        return;
    }
    UILocalNotification *notification=[[UILocalNotification alloc] init]; 
    if (notification != nil) {
        NSDate *now = [[NSDate alloc] init];
        NSTimeInterval interval = LONGTERM_REVIEW_INTERVAL;
        notification.fireDate = [now dateByAddingTimeInterval:interval];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"上次背诵中，你有些单词记得比较熟，老师还是建议你稍微再看下";
        NSDictionary *data = [NSDictionary dictionaryWithObject:[[[self.longTermList objectID] URIRepresentation] absoluteString] forKey:@"list_id"];
        notification.userInfo = data;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
