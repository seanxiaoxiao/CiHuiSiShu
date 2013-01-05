//
//  VSAppRecord.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSAppRecord.h"
#import "VSUtils.h"

@implementation VSAppRecord

@dynamic migrated;

+ (VSAppRecord *)getAppRecord
{
    __autoreleasing NSError *error = nil;
    NSEntityDescription *contextDescription = [NSEntityDescription entityForName:@"VSAppRecord" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *contextRequest = [[NSFetchRequest alloc] init];
    [contextRequest setEntity:contextDescription];
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:contextRequest error:&error];
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    }
    else {
        VSAppRecord *appRecord = [NSEntityDescription insertNewObjectForEntityForName:@"VSAppRecord" inManagedObjectContext:[VSUtils currentMOContext]];
        appRecord.migrated = [NSNumber numberWithBool:NO];
        [VSUtils saveEntity];
        return appRecord;
    }
}

@end
