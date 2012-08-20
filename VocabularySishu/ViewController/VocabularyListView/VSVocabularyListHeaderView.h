//
//  VSVocabularyListHeaderView.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/25/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSConstant.h"
#import "VSVocabulary.h"

@interface VSVocabularyListHeaderView : UIView

@property (nonatomic, retain) UIImageView *penBG;
@property (nonatomic, retain) UIImageView *penFG;
@property (nonatomic, retain) UIImageView *inkHeader;
@property (nonatomic, retain) UIImageView *inkNeck;
@property (nonatomic, retain) UIImageView *inkBody;
@property (nonatomic, retain) UIImageView *inkFooter;

@property (nonatomic, retain) UIImage *inkHeadImage;
@property (nonatomic, retain) UIImage *inkNeckImage;
@property (nonatomic, retain) UIImage *inkBodyImage;
@property (nonatomic, retain) UIImage *inkFooterImage;
@property (nonatomic, retain) UILabel *finishProgressLabel;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;


- (void) updateProgress:(double)progress; 

@end
