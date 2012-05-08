//
//  VSUtils.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSUtils.h"
#import "VSAppDelegate.h"

@implementation VSUtils

+ (NSManagedObjectContext *)currentMOContext
{
    __autoreleasing VSAppDelegate *appDelegate = (VSAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

@end
