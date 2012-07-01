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

+ (void)saveEntity
{
    __autoreleasing NSError *error = nil;
    if (![[VSUtils currentMOContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
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

+ (NSDate *)getNow
{
    NSTimeZone *timezone = [NSTimeZone defaultTimeZone];
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

+ (BOOL) vocabularySame:(VSVocabulary *)first with:(VSVocabulary *)second
{
    return [first.spell isEqualToString:second.spell];
}

+ (NSString *)normalizeString:(NSString *)source
{
    return [NSString stringWithCString:[source cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];

}

@end
