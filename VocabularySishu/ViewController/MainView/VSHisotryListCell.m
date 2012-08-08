//
//  VSHisotryListCell.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSHisotryListCell.h"

@implementation VSHisotryListCell
@synthesize dateLabel;
@synthesize reciteLabel;
@synthesize notRememberWellLabel;
@synthesize detailImage;
@synthesize list;
@synthesize numberFormatter;
@synthesize backgroundImage ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setPositiveFormat:@"0.0%;0.0%-0.0%"];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 16, 120, 30)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = UITextAlignmentLeft;
        self.dateLabel.textColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:20];
        self.dateLabel.shadowOffset = CGSizeMake(0, 1);
        self.dateLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];
    
        self.reciteLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 160, 24)];
        self.reciteLabel.textColor = [UIColor colorWithHue:220.0 / 360.0 saturation:0.2 brightness:0.5 alpha:1];
        self.reciteLabel.backgroundColor = [UIColor clearColor];
        self.reciteLabel.textAlignment = UITextAlignmentRight;
        self.reciteLabel.font = [UIFont boldSystemFontOfSize:14];
        self.reciteLabel.shadowOffset = CGSizeMake(0, 1);
        self.reciteLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];

        self.notRememberWellLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 28, 160, 24)];
        self.notRememberWellLabel.backgroundColor = [UIColor clearColor];
        self.notRememberWellLabel.textAlignment = UITextAlignmentRight;
        self.notRememberWellLabel.font = [UIFont boldSystemFontOfSize:14];
        self.notRememberWellLabel.textColor = [UIColor colorWithHue:0 saturation:0.2 brightness:0.6 alpha:1];
        self.notRememberWellLabel.shadowOffset = CGSizeMake(0, 1);
        self.notRememberWellLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];

        self.detailImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellAccessory"]];
        CGRect frame = self.detailImage.frame;
        frame.origin.x = 275;
        frame.origin.y = 24;
        self.detailImage.frame = frame;
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.reciteLabel];
        [self.contentView addSubview:self.notRememberWellLabel];
        [self.contentView addSubview:self.detailImage];
    }
    return self;
}

- (void)initWithList:(VSList *)theList andRow:(int)row
{
    self.list = theList;
    if (self.backgroundImage != nil) {
        [self.backgroundImage removeFromSuperview];
        self.backgroundImage = nil;
    }
    if (row % 2 == 0) {
        self.backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"TimeLineCellLight"]];
        [self.contentView addSubview:self.backgroundImage];
        [self.contentView sendSubviewToBack:self.backgroundImage];
    }
    else {
        self.backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"TimeLineCellDark"]];
        [self.contentView addSubview:self.backgroundImage];
        [self.contentView sendSubviewToBack:self.backgroundImage];
    }
    self.dateLabel.text = self.list.name;
    self.reciteLabel.text = [NSString stringWithFormat:@"背诵%d个单词", [self.list.listVocabularies count]];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self.list notWellRate]]];
    self.notRememberWellLabel.text = [NSString stringWithFormat:@"%@不靠谱", formattedNumberString];
}

- (void)addCellShadow
{
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOpacity = .4;
}

- (void)removeCellShadow
{
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
