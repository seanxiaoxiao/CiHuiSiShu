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
    CGRect frame = CGRectMake(0, 0, 50, 50); 
    self.button = [[UIButton alloc] initWithFrame:frame];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [self.button setTitle:list.name forState:UIControlStateNormal]; 
    [self.button addTarget:self action:@selector(toList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
//    int starCount = [list rememberRate] / 0.33;
//    int originX = 5;
//    for (int i = 0; i < starCount; i++) {
//        UIImageView *starImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"Star"]];
//        starImage.frame = CGRectMake(originX, 50, starImage.image.size.width, starImage.image.size.height);
//        originX += starImage.image.size.width + 5;
//        [self addSubview:starImage];
//    }
//    for (int i = 0 ; i < 3 - starCount; i++) {
//        UIImageView *noStarImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"StarNone"]];
//        noStarImage.frame = CGRectMake(originX, 50, noStarImage.image.size.width, noStarImage.image.size.height);
//        originX += noStarImage.image.size.width + 5;
//        [self addSubview:noStarImage];
//    }
}

- (void)toList
{
    [VSUtils toGivenList:self.theList];
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
