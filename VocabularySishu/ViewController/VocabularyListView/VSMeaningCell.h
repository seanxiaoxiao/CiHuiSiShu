//
//  VSMeaningCell.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSMeaning.h"

@interface VSMeaningCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, retain) NSArray *_meanings;
@property (nonatomic, retain) UIWebView *meaningView;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) BOOL loaded;

- (void)setMeaningContent:(NSArray *)meanings;


@end
