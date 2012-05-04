//
//  Vocabulary.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vocabulary : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) UNKNOWN_TYPE meet;

@end
