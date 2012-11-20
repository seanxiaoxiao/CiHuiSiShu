//
//  VSSingleListView.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSSingleListView.h"
#import "MobClick.h"
#import "VSListRecord.h"

@implementation VSSingleListView

@synthesize index;
@synthesize button;
@synthesize theList;
@synthesize indicator;
@synthesize listNameLabel;
@synthesize stars;
@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithList:(VSList *)list
{
    self.theList = list;
    self.selected = NO;
    self.stars = [[NSMutableArray alloc] init];
    UIImage *listImage = nil;
    UIImage *listHighlightImage = nil;
    
    if ([self.theList.repository isCategoryRepo]) {
        listImage = [VSUtils fetchImg:@"UnitC"];
        listHighlightImage = [VSUtils fetchImg:@"UnitCHighLighted"];
    }
    else {
        listImage = [VSUtils fetchImg:@"Unit"];
        listHighlightImage = [VSUtils fetchImg:@"UnitHighLighted"];
    }
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, listImage.size.width, listImage.size.height)];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setBackgroundImage:listImage forState:UIControlStateNormal];
    [self.button setBackgroundImage:listHighlightImage forState:UIControlStateHighlighted];
    [self.button addTarget:self action:@selector(toList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    self.listNameLabel = nil;
    if ([self.theList.repository isCategoryRepo]) {
        self.listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 13, 60, 20)];
        self.listNameLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
        self.listNameLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    }
    else {
        self.listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 46, 20)];
        self.listNameLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
    }
    self.listNameLabel.textColor = [UIColor blackColor];
    self.listNameLabel.alpha = 0.7f;
    self.listNameLabel.shadowOffset = CGSizeMake(0, 1);
    self.listNameLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.listNameLabel.minimumFontSize = 12;
    self.listNameLabel.adjustsFontSizeToFitWidth = YES;
    self.listNameLabel.backgroundColor = [UIColor clearColor];
    if (self.theList == nil) {
        self.listNameLabel.frame = CGRectMake(0, 10, 46, 20);
        self.listNameLabel.text = @"+";
        self.listNameLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:28];

    }
    else {
        self.listNameLabel.text = [theList displayName];
    }
    [self.listNameLabel setTextAlignment:UITextAlignmentCenter];
    [self addSubview:listNameLabel];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.center = CGPointMake(23, 45);
    [self addSubview:self.indicator];
}

- (void)toList
{
    if (self.theList) {
        [MobClick event:EVENT_SELECT_LIST];
        [VSUtils toGivenList:self.theList];
    }
    else {
        [VSUtils openSeries];
    }
}

- (void)selectList
{
    UIImage *listSelectedImage = nil;
    if ([self.theList.repository isCategoryRepo]) {
        listSelectedImage = [VSUtils fetchImg:@"UnitCHighLighted"];
    }
    else {
        listSelectedImage = [VSUtils fetchImg:@"UnitSelected"];
    }
    [self.button setBackgroundImage:listSelectedImage forState:UIControlStateNormal];
    self.selected = YES;
}

- (void)unselectList
{
    self.selected = NO;
    UIImage *listImage = nil;
    if ([self.theList.repository isCategoryRepo]) {
        listImage = [VSUtils fetchImg:@"UnitC"];
    }
    else {
        listImage = [VSUtils fetchImg:@"Unit"];
    }
    [self.button setBackgroundImage:listImage forState:UIControlStateNormal];
}

- (void)showStars
{
    for (UIImageView *exsitedStar in self.stars) {
        [exsitedStar removeFromSuperview];
    }
    self.stars = [[NSMutableArray alloc] init];
    int originX = 5;
    if ([self.theList.repository isCategoryRepo]) {
        originX = 8;
    }
    double rememberRate = [[self.theList getListRecord] rememberRate];
    int starCount = 0;
    if (rememberRate < 0.2) {
        starCount = 0;
    }
    else if (rememberRate < 0.4) {
        starCount = 1;
    }
    else if (rememberRate < 0.9) {
        starCount = 2;
    }
    else {
        starCount = 3;
    }
    
    for (int i = 0; i < starCount; i++) {
        UIImageView *starImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"StarSmall"]];
        starImage.frame = CGRectMake(originX, 44, starImage.image.size.width, starImage.image.size.height);
        originX += starImage.image.size.width;
        if ([self.theList.repository isCategoryRepo]) {
            originX += 12;
        }
        [self addSubview:starImage];
        [stars addObject:starImage];
    }
}



@end
