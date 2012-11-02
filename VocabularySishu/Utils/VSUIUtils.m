//
//  VSUIUtils.m
//  VocabularySishu
//
//  Created by Xiao Xiao on 10/20/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSUIUtils.h"
#import "VSUtils.h"

@implementation VSUIUtils

+ (UIBarButtonItem *)makeBackButton:(id)target selector:(SEL)selector
{
    UIImage* backImage= [VSUtils fetchImg:@"NavBackButton"];
    CGRect frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButtonItem;
}

@end
