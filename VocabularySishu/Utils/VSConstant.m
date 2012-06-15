//
//  VSConstant.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/22/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSConstant.h"

@implementation VSConstant

+ (NSNumber *)LIST_STATUS_NEW
{
    return [NSNumber numberWithInt:0];
}

+ (NSNumber *)LIST_STATUS_PROCESSING
{
    return [NSNumber numberWithInt:1];
}

+ (NSNumber *)LIST_STATUS_FINISH
{
    return [NSNumber numberWithInt:2];
}


@end
