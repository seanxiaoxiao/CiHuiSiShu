//
//  VSListRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VSList;

@interface VSListRecord : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * finishPlanDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rememberCount;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;

- (void)initWithVSList: (VSList *)list;

@end
