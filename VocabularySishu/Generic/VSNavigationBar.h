//
//  VSNavigationBar.h
//  VocabularySishu
//
//  Created by xiao xiao on 7/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSUtils.h"

@interface VSNavigationBar : UINavigationBar

@property (nonatomic, retain) UIImageView *backgroundImageView;

- (void)updateBackgroundImage;

@end
