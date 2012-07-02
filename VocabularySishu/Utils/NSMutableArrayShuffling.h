//
//  NSMutableArrayShuffling.h
//  VocabularySishu
//
//  Created by xiao xiao on 7/2/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)

- (void)shuffle;

@end