//
//  VSSingleListView.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSSingleListView.h"

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
    UIImage *listImage = [VSUtils fetchImg:@"Unit"];
    UIImage *listHighlightImage = [VSUtils fetchImg:@"UnitHighLighted"];
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, listImage.size.width, listImage.size.height)];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setBackgroundImage:listImage forState:UIControlStateNormal];
    [self.button setBackgroundImage:listHighlightImage forState:UIControlStateHighlighted];
    [self.button addTarget:self action:@selector(toList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    self.listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 46, 20)];
    self.listNameLabel.textColor = [UIColor blackColor];
    self.listNameLabel.alpha = 0.7f;
    self.listNameLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:16];
    self.listNameLabel.shadowOffset = CGSizeMake(0, 1);
    self.listNameLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.listNameLabel.minimumFontSize = 12;
    self.listNameLabel.adjustsFontSizeToFitWidth = YES;
    self.listNameLabel.backgroundColor = [UIColor clearColor];
    self.listNameLabel.text = [theList displayName];
    [self.listNameLabel setTextAlignment:UITextAlignmentCenter];
    [self addSubview:listNameLabel];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.center = CGPointMake(23, 45);
    [self addSubview:self.indicator];
}

- (void)toList
{
    [VSUtils toGivenList:self.theList];
}

- (void)selectList
{
    UIImage *listSelectedImage = [VSUtils fetchImg:@"UnitSelected"];
    [self.button setBackgroundImage:listSelectedImage forState:UIControlStateNormal];
    self.selected = YES;
}

- (void)unselectList
{
    self.selected = NO;
    UIImage *listImage = [VSUtils fetchImg:@"Unit"];
    [self.button setBackgroundImage:listImage forState:UIControlStateNormal];
}

- (void)showStars
{
    for (UIImageView *exsitedStar in self.stars) {
        [exsitedStar removeFromSuperview];
    }
    self.stars = [[NSMutableArray alloc] init];
    int originX = 5;
    int starCount = [self.theList rememberRate] / 0.33;
    
    for (int i = 0; i < starCount; i++) {
        UIImageView *starImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"StarSmall"]];
        starImage.frame = CGRectMake(originX, 44, starImage.image.size.width, starImage.image.size.height);
        originX += starImage.image.size.width ;
        [self addSubview:starImage];
        [stars addObject:starImage];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
