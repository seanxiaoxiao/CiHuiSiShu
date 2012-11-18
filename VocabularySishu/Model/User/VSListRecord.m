//
//  VSListRecord.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 11/11/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSListRecord.h"
#import "VSList.h"

@implementation VSListRecord

@dynamic createdDate;
@dynamic finishPlanDate;
@dynamic name;
@dynamic rememberCount;
@dynamic round;
@dynamic status;
@dynamic type;

- (void)initWithVSList:(VSList *)list
{
    self.createdDate = list.createdDate;
    self.finishPlanDate = list.finishPlanDate;
    self.name = list.name;
    self.rememberCount = list.rememberCount;
    self.round = list.round;
    self.status = list.status;
    self.type = list.type;
}

@end
