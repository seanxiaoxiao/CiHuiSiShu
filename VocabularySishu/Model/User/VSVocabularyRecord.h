//
//  VSVocabularyRecord.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 10/1/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VSVocabularyRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * remember;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSNumber * meet;

@end
