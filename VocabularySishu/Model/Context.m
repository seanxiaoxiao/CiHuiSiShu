//
//  Context.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "Context.h"
#import "List.h"
#import "ListVocabulary.h"
#import "Repository.h"


@implementation Context

@dynamic currentList;
@dynamic currentRepository;
@dynamic currentListVocabulary;

- (List *) fetchCurrentList
{
    if (self.currentList == nil) {
        __autoreleasing NSError *error = nil;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"List" inManagedObjectContext:[VSUtils currentMOContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSArray *array = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
        self.currentList = [array objectAtIndex:0];
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    return self.currentList;
}


@end
