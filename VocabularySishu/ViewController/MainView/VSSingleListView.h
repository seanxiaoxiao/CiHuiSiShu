//
//  VSSingleListView.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSList.h"
#import "VSContext.h"

@interface VSSingleListView : UIView

@property (nonatomic, assign) int index;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) VSList *theList;
@property (nonatomic, retain) UILabel *listNameLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)initWithList:(VSList *)list andContext:(VSContext *)ctx;

- (void)loadScore;

@end
