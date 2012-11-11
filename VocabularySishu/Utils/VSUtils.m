//
//  VSUtils.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSUtils.h"
#import "VSAppDelegate.h"
#import <sys/xattr.h>

@implementation VSUtils

+ (NSManagedObjectContext *)currentMOContext
{
    __autoreleasing VSAppDelegate *appDelegate = (VSAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

+ (void)saveEntity
{
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+ (NSManagedObject *)get:(NSManagedObjectID *)moID
{
    NSError *error = nil;
    return [[VSUtils currentMOContext] existingObjectWithID:moID error:&error];
}

+ (UIImage *)fetchImg:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}


+ (NSDate *)getToday
{
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSDate *now = [[NSDate alloc] init];
    NSInteger seconds = [timezone secondsFromGMTForDate: now];
    NSDate *localNow = [NSDate dateWithTimeInterval: seconds sinceDate: now];

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:now];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    return [cal dateByAddingComponents:components toDate:localNow options:0];
}

+ (NSDate *)getNow
{
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    NSDate *now = [[NSDate alloc] init];
    NSInteger seconds = [timezone secondsFromGMTForDate: now];
    return [NSDate dateWithTimeInterval: seconds sinceDate: now];
}

+ (NSDate *)converToNormalDate:(NSDate *)date
{
    NSTimeZone *timezone = [NSTimeZone defaultTimeZone];
    NSDate *now = [[NSDate alloc] init];
    NSInteger seconds = [timezone secondsFromGMTForDate: now];
    return [NSDate dateWithTimeInterval: -seconds sinceDate: date];
}

+ (NSString *)getBundleName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    return [info objectForKey:@"CFBundleName"];
}

+ (NSString *)getBundleVersion
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    return [info objectForKey:@"CFBundleVersion"];
}

+ (BOOL) vocabularySame:(VSVocabulary *)first with:(VSVocabulary *)second
{
    return [first.spell isEqualToString:second.spell];
}

+ (NSString *)normalizeString:(NSString *)source
{
    return [NSString stringWithCString:[source cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];

}

+ (void)copySQLite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"VocabularySishu.sqlite"];
    NSString *urlString = [NSString stringWithFormat:@"file://%@", filePath];
    NSURL* storeURL = [NSURL URLWithString:urlString];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"VocabularySishu" ofType:@"sqlite"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
            [fileManager copyItemAtPath:resourcePath toPath:filePath error:&error];
        }
    }
}


+ (void)toGivenList:(VSList *)list
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    
    VSContext *context = [VSContext getContext];
    if (list != nil) {
        [context fixCurrentList:list];
        [context fixRepository:list.repository];
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = list;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];

        [navigationController pushViewController:vocabularyListViewController animated:YES];
    }
}

+ (void)toNextList:(VSList *)currentList
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    
    VSList *nextList = [currentList nextList];
    VSContext *context = [VSContext getContext];
    if (nextList != nil) {
        [context fixCurrentList:nextList];
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = nextList;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];

        [UIView beginAnimations:nil context:NULL];
        [navigationController popViewControllerAnimated:NO];
        [UIView commitAnimations];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationTransitionCurlUp];
        [UIView setAnimationDuration:0.5];
        [navigationController pushViewController:vocabularyListViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

+ (void)toPreviousList:(VSList *)currentList
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    
    VSList *nextList = [currentList previousList];
    VSContext *context = [VSContext getContext];
    if (nextList != nil) {
        [context fixCurrentList:nextList];
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = nextList;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.375];
        [navigationController popViewControllerAnimated:NO];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationTransitionCurlDown];
        [UIView setAnimationDuration:0.75];
        [navigationController pushViewController:vocabularyListViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

+ (void)reloadCurrentList:(VSList *)currentList
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    
    if (currentList != nil) {
        VSVocabularyListViewController *vocabularyListViewController = [VSVocabularyListViewController alloc];
        vocabularyListViewController.currentList = currentList;
        vocabularyListViewController = [vocabularyListViewController initWithNibName:@"VSVocabularyListViewController" bundle:nil];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.4];
        [navigationController popViewControllerAnimated:NO];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationTransitionCurlDown];
        [UIView setAnimationDuration:0.4];
        [navigationController pushViewController:vocabularyListViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

+ (void)showGuidPage
{
    VSGuideViewController *guideViewController = [[VSGuideViewController alloc] initWithNibName:@"VSGuideViewController" bundle:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [navigationController pushViewController:guideViewController animated:NO];
}

+ (void)openSeries
{
    [ [ UIApplication sharedApplication ] openURL: [ NSURL URLWithString: [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 558382812] ] ];
}

+ (NSString *)getUMengKey
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings objectForKey:@"UMengKey"];
}

+ (NSNumber *)getAppId
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings objectForKey:@"AppID"];
}

+ (NSString *)getBundleId
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings objectForKey:@"BundleID"];
}

@end
