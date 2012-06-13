//
//  VSUtils.m
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "VSUtils.h"
#import "VSAppDelegate.h"

@implementation VSUtils

+ (NSManagedObjectContext *)currentMOContext
{
    __autoreleasing VSAppDelegate *appDelegate = (VSAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

+ (UIImage *)fetchImg:(NSString *)imageName
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
        NSString *retinaImageName = [NSString stringWithFormat:@"retina-%@", imageName];
        UIImage *originalImage = [UIImage imageNamed:retinaImageName];
        UIImage *scaledImage = [UIImage imageWithCGImage:[originalImage CGImage] 
                            scale:2.0 orientation:UIImageOrientationUp];
        return scaledImage;
    }
    else {
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }
}

+ (VSContext *)fetchContext
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"VSContext" inManagedObjectContext:[VSUtils currentMOContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    __autoreleasing NSError *error = nil;
    NSArray *results = [[VSUtils currentMOContext] executeFetchRequest:request error:&error];
    if ([results count] == 1) {
        return [results objectAtIndex:0];
    }
    else {
        VSContext *context = [NSEntityDescription insertNewObjectForEntityForName:@"VSContext" inManagedObjectContext:[VSUtils currentMOContext]];
        if (![[VSUtils currentMOContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        return context;
    }
}

+ (NSDate *)getToday
{
    NSTimeZone *timezone = [NSTimeZone defaultTimeZone];
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

+ (BOOL) vocabularySame:(VSVocabulary *)first with:(VSVocabulary *)second
{
    return [first.spell isEqualToString:second.spell];
}

@end
