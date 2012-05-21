//
//  VSUtils.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Context.h"

@class Context;

@interface VSUtils : NSObject

+ (NSManagedObjectContext *)currentMOContext;

+ (UIImage *)fetchImg:(NSString *)imageName;

+ (Context *)fetchContext;

@end
