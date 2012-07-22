//
//  VSRepository.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/24/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepository.h"
#import "VSList.h"


@implementation VSRepository

@dynamic name;
@dynamic order;
@dynamic lists;
@dynamic finishedRound;

+ (NSArray *)allRepos
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSRepository" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortOrderDescriptor, nil];
    return [[[VSUtils currentMOContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)finishThisRound
{
    self.finishedRound = [NSNumber numberWithInt:[self.finishedRound intValue] + 1];
    for (VSList *listInRepo in self.lists) {
        listInRepo.status = [VSConstant LIST_STATUS_NEW];
    }
    [VSUtils saveEntity];
}

@end
