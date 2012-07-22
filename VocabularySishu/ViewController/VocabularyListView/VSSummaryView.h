//
//  VSSummaryView.h
//  VocabularySishu
//
//  Created by xiao xiao on 7/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSVocabulary.h"

@interface VSSummaryView : UIView

@property (nonatomic, retain) VSVocabulary* vocabulary;

@property (nonatomic, strong) UIImageView* backgroundImage;
@property (nonatomic, strong) UILabel* summaryLabel;

@end
