//
//  VSVocabularyPlayer.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 12/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyPlayer.h"
#import "VSVocabulary.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import <AVFoundation/AVAudioPlayer.h>

static VSVocabularyPlayer *player = nil;

@implementation VSVocabularyPlayer
@synthesize request;

+ (VSVocabularyPlayer *)getPlayer
{
    if (player == nil) {
        [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
        player = [[VSVocabularyPlayer alloc] init];
    }
    return player;
}


- (void)play:(VSVocabulary *)vocabulary
{
    if ([[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
        self.request = [ASIHTTPRequest requestWithURL:[vocabulary audioURL]];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setSecondsToCache:60 * 60 * 24 * 30];
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [self.request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [self.request responseData];
    int statusCode = [self.request responseStatusCode];
    
    if (statusCode == 200 || statusCode == 301 || statusCode == 302 || statusCode == 307) {
        NSError *error = [self.request error];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:responseData error:&error];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0f;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    else {
        [self requestFailed:self.request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [self.request error];
    NSLog(@"%@", [error localizedDescription]);
}


@end
