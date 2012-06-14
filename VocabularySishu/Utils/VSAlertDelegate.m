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
    UINavigationController *navigationController = window.rootViewController.navigationController;
    if ([self.currentList isHistoryList]) {
        [navigationController popViewControllerAnimated:YES];
    }
    else {
        VSList *nextList = [self.currentList nextList];
        if (nextList != nil) {
            VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
            vocabularyListViewController.currentList = nextList;
            NSLog(@"%@", nextList.order);
            NSLog(@"%@", nextList.name);
            vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];          
            NSLog(@"Navigation, %@", navigationController);
            [navigationController popViewControllerAnimated:NO];
            NSLog(@"Navigation, %@", navigationController);            
            [navigationController pushViewController:vocabularyListViewController animated:NO]; 
        }
    }
}

@end
