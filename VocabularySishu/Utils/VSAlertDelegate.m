//
//  VSAlertDelegate.m
//  VocabularySishu
//
//  Created by xiao xiao on 6/13/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSAlertDelegate.h"

@implementation VSAlertDelegate

@synthesize currentList;

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [currentList finish];
    if ([self.currentList isHistoryList]) {
        [navigationController popViewControllerAnimated:YES];
    }
    else {
        [VSUtils toNextList:self.currentList];
    }
}

@end
