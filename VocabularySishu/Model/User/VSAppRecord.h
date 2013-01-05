//
//  VSAppRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VSAppRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * migrated;

+ (VSAppRecord *)getAppRecord;

@end
