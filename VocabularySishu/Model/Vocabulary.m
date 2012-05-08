//
//  Vocabulary.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "Vocabulary.h"


@implementation Vocabulary

@dynamic spell;
@dynamic meet;
@dynamic phonetic;

- (NSString *) description
{
    return [NSString stringWithFormat:@"Vocabulary %@ sounds %@ and meet %@ times", self.spell, self.phonetic, self.meet];
}

@end
