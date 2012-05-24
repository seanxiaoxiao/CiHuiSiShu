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

@end
