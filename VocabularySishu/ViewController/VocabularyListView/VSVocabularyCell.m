//
//  VSVocabularyCell.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/2/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyCell.h"

@implementation VSVocabularyCell

@synthesize vocabulary;
@synthesize vocabularyLabel;
@synthesize summaryLabel;
@synthesize vocabularyContainerView;
@synthesize summaryContainerView;
@synthesize clearImage;
@synthesize curlUp;
@synthesize tapeBodyImage;
@synthesize tapeHeadImage;
@synthesize tapeTailImage;
@synthesize clearing;
@synthesize lineImage;
@synthesize lastGestureX;
@synthesize curlUpTimer;
@synthesize curling;
@synthesize clearShow;
@synthesize clearContainer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.vocabularyContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, VOCAVULARY_CELL_HEIGHT)];
        self.summaryContainerView = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 0, VOCAVULARY_CELL_HEIGHT)];
        self.lineImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellLine"]];

        self.clearImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellClear"]];
        self.clearContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, VOCAVULARY_CELL_HEIGHT)];
        self.clearContainer.clipsToBounds = YES;
        [self.clearContainer addSubview:self.clearImage];
        [self.contentView addSubview:self.clearContainer];

        self.vocabularyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, self.frame.size.height)];
        self.vocabularyLabel.text = self.vocabulary.spell;
        [self.vocabularyLabel setTextAlignment:UITextAlignmentCenter];
        self.vocabularyLabel.backgroundColor = [UIColor clearColor];
        self.vocabularyLabel.textColor = [UIColor blackColor];
        self.vocabularyLabel.alpha = 0.7f;
        self.vocabularyLabel.font = [UIFont fontWithName:@"Verdana" size:18];
        self.vocabularyLabel.shadowOffset = CGSizeMake(0, 1);
        self.vocabularyLabel.shadowColor = [UIColor whiteColor];

        [self.vocabularyContainerView addSubview:self.vocabularyLabel];
        [self.vocabularyContainerView addSubview:lineImage];
        [self.vocabularyContainerView sendSubviewToBack:lineImage];
        self.vocabularyContainerView.clipsToBounds = YES;
        [self.contentView addSubview:self.vocabularyContainerView];

        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 6, 250, self.frame.size.height)];
        self.summaryLabel.text = self.vocabulary.summary;
        self.summaryLabel.textColor = [UIColor blackColor];
        self.summaryLabel.alpha = 0.9f;
        self.summaryLabel.font = [UIFont fontWithName:@"Verdana" size:14];
        self.summaryLabel.shadowOffset = CGSizeMake(0, 1);
        self.summaryLabel.shadowColor = [UIColor whiteColor];
        self.summaryLabel.minimumFontSize = 12;
        self.summaryLabel.adjustsFontSizeToFitWidth = YES;
        self.summaryLabel.backgroundColor = [UIColor clearColor];
        [self.summaryLabel setTextAlignment:UITextAlignmentCenter];

        self.summaryLabel.bounds = CGRectMake(0, 0, 300, VOCAVULARY_CELL_HEIGHT);

        self.summaryContainerView.clipsToBounds = YES;
        [self.summaryContainerView addSubview:self.summaryLabel];
        self.summaryContainerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.summaryContainerView];
        [self.contentView sendSubviewToBack:self.summaryContainerView];

        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellBG"]];
        [self.contentView addSubview:backgroundImage];
        [self.contentView sendSubviewToBack:backgroundImage];

        tapeHeadImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"TapeHead"]];
        tapeBodyImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"TapeBody"]];
        tapeTailImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"TapeTail"]];

        [self.contentView addSubview:tapeTailImage];
        [self.contentView addSubview:tapeHeadImage];
        [self.contentView addSubview:tapeBodyImage];

        tapeTailImage.hidden = YES;
        tapeHeadImage.hidden = YES;
        tapeBodyImage.hidden = YES;
    }
    return self;
}

- (void) clearVocabulry:(BOOL)clear
{
    self.clearing = YES;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveLinear 
        animations:^{
            CGFloat width = clear ? 320 : 0;
            self.clearContainer.frame = CGRectMake(0, 0, width, VOCAVULARY_CELL_HEIGHT);
        }
        completion:^(BOOL finished) {
            self.clearing = NO;
            self.clearShow = NO;
            if (finished == YES && clear) {
                NSMutableDictionary *orientationData = [[NSMutableDictionary alloc] init];
                [orientationData setValue:self.vocabulary forKey:@"vocabulary"];
                NSNotification *notification = [NSNotification notificationWithName:CLEAR_VOCABULRY object:nil userInfo:orientationData];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }];
}

- (void) curlUp:(CGFloat)gestureX
{
    lastGestureX = gestureX;
    curlUpTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(doCurlUp) userInfo:nil repeats:YES];
}

- (void) doCurlUp
{
    self.curling = YES;
    if (lastGestureX < 170) {
        lastGestureX = lastGestureX - 20;
        [self dragSummary:lastGestureX];
    }
    if (lastGestureX >= 170) {
        lastGestureX = lastGestureX + 10;
        [self dragSummary:lastGestureX];
    }
    if (lastGestureX < - 180) {
        [self dragSummary:-180];
        [curlUpTimer invalidate];
        self.curling = NO;
        self.curlUp = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (lastGestureX > 260) {
        [curlUpTimer invalidate];
        self.curling = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void) doCurlDown
{
    self.curling = YES;
    if (lastGestureX < 80) {
        lastGestureX = lastGestureX - 10;
        [self dragSummary:lastGestureX];
    }
    if (lastGestureX >= 80) {
        lastGestureX = lastGestureX + 20;
        [self dragSummary:lastGestureX];
    }
    if (lastGestureX < - 180) {
        [self dragSummary:-180];
        [curlUpTimer invalidate];
        self.curling = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    if (lastGestureX > 260) {
        [curlUpTimer invalidate];
        self.curlUp = NO;
        self.curling = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void) curlDown:(CGFloat)gestureX
{
    lastGestureX = gestureX;
    curlUpTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(doCurlDown) userInfo:nil repeats:YES];
}

- (void) dragSummary:(CGFloat)gestureX
{
    if (gestureX > 210) {
        tapeTailImage.hidden = YES;
        tapeHeadImage.hidden = YES;
        tapeBodyImage.hidden = YES;
        self.vocabularyContainerView.frame = CGRectMake(0, 0, 320, VOCAVULARY_CELL_HEIGHT);
        self.summaryContainerView.frame = CGRectMake(320, 0, 0, VOCAVULARY_CELL_HEIGHT);
    }
    else {
        tapeTailImage.hidden = NO;
        tapeHeadImage.hidden = NO;
        tapeBodyImage.hidden = NO;

        CGFloat bodyLength = gestureX > 200 ? 0 : - (8.0 / 19.0) * gestureX + (1600.0 / 19.0);
        CGFloat tailX = gestureX + bodyLength + 24;
        tapeHeadImage.frame = CGRectMake(gestureX + 20, 1, 4, VOCAVULARY_CELL_HEIGHT);
        tapeBodyImage.frame = CGRectMake(gestureX + 24, 1, bodyLength, VOCAVULARY_CELL_HEIGHT);
        tapeTailImage.frame = CGRectMake(tailX, 1, 41, 56);
        self.vocabularyContainerView.frame = CGRectMake(0, 0, gestureX + 20, VOCAVULARY_CELL_HEIGHT);
        self.summaryContainerView.frame = CGRectMake(gestureX + 30, 0, 290 - gestureX, VOCAVULARY_CELL_HEIGHT);
        self.summaryLabel.frame = CGRectMake(-gestureX + 15, 0, 250, VOCAVULARY_CELL_HEIGHT);
    }
}

- (void) showClearView
{
    self.clearShow = YES;
}

- (void) moveClearView:(CGFloat)gestureX
{
    self.clearContainer.frame = CGRectMake(0, 0, gestureX, VOCAVULARY_CELL_HEIGHT);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
