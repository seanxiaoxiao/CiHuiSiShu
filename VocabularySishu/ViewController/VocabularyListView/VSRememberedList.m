//
//  VSRememberedList.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRememberedList.h"

@implementation VSRememberedToken

@synthesize index;
@synthesize record;

@end

@implementation VSRememberedList

@synthesize rememberedList;

- (id) init
{
    self = [super init];
    if (self) {
        self.rememberedList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addNewToken:(int )index withRecord:(VSListVocabularyRecord *)record
{
    VSRememberedToken *newToken = [[VSRememberedToken alloc] init];
    newToken.index = index;
    newToken.record = record;
    [self.rememberedList addObject:newToken];
}

- (VSRememberedToken *) popToken
{
    if (![self isEmpty]) {
        VSRememberedToken *record = [self.rememberedList lastObject];
        [self.rememberedList removeLastObject];
        return record;
    }
    return nil;
}

- (BOOL) isEmpty
{
    return [self.rememberedList count] == 0;
}

@end
