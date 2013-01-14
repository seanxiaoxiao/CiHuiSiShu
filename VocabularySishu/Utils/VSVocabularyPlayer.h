//
//  VSVocabularyPlayer.h
//  VocabularySishu
//
//  Created by Xiao Xiao on 12/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VSVocabulary;
@class ASIHTTPRequest;
@class AVAudioPlayer;

@interface VSVocabularyPlayer : NSObject

@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;

+ (VSVocabularyPlayer *) getPlayer;

- (void)play:(VSVocabulary *)vocabulary;

@end
