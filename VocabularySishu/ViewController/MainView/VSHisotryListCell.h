//
//  VSHisotryListCell.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VSList.h"
#import "VSUtils.h"

@interface VSHisotryListCell : UITableViewCell

@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *reciteLabel;
@property (nonatomic, retain) UILabel *notRememberWellLabel;
@property (nonatomic, retain) UIImageView *detailImage;
@property (nonatomic, retain) VSList *list;
@property (nonatomic, retain) UIView *viewSelected;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) UIImageView *backgroundImage;

- (void)initWithList:(VSList *)theList andRow:(int)row;

- (void)initWithLabel:(NSString *)title;

@end
