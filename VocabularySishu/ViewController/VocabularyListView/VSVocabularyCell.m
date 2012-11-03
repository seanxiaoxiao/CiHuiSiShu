//
//  VSVocabularyCell.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/2/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSVocabularyCell.h"
#import "MobClick.h"

@implementation VSVocabularyCell

@synthesize _vocabulary;
@synthesize vocabularyLabel;
@synthesize summaryLabel;
@synthesize vocabularyContainerView;
@synthesize summaryContainerView;
@synthesize clearImage;
@synthesize curlUp;
@synthesize hadCurlUp;
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
@synthesize cellAccessoryImage;
@synthesize scoreDownImage;
@synthesize scoreUpImage;

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

        self.vocabularyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6.5, 300, self.frame.size.height)];
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

        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 6.5, 250, self.frame.size.height)];
        self.summaryLabel.textColor = [UIColor blackColor];
        self.summaryLabel.alpha = 0.9f;
        self.summaryLabel.font = [UIFont fontWithName:@"Verdana" size:16];
        self.summaryLabel.shadowOffset = CGSizeMake(0, 1);
        self.summaryLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.6];
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
        [self.contentView addSubview:self.clearContainer];

        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellBG"]];
        [self.contentView addSubview:backgroundImage];
        [self.contentView sendSubviewToBack:backgroundImage];

        cellAccessoryImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellAccessory"]];
        CGRect frame = cellAccessoryImage.frame;
        frame.origin.x = 320 - 30;
        frame.origin.y = 20;
        cellAccessoryImage.frame = frame;
        cellAccessoryImage.hidden = YES;
        [self.contentView addSubview:self.cellAccessoryImage];
        
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


- (void) initWithVocabulary:(VSVocabulary *)vocabulary
{
    self._vocabulary = vocabulary;
    self.vocabularyLabel.text = self._vocabulary.spell;
    self.summaryLabel.text = self._vocabulary.summary;
}

- (void) clearVocabulry:(BOOL)clear
{
    self.clearing = YES;
    if (clear && !hadCurlUp) {
        [self scoreUp];
    }
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveLinear
        animations:^{
            CGFloat width = clear ? 320 : 0;
            self.clearContainer.frame = CGRectMake(0, 0, width, VOCAVULARY_CELL_HEIGHT);
        }
        completion:^(BOOL finished) {
            if (finished == YES && clear) {
                [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationCurveEaseIn
                    animations:^{
                        self.vocabularyContainerView.alpha = 0;
                        self.clearContainer.alpha = 0;
                    }
                    completion:^(BOOL finished) {
                        self.summaryContainerView.alpha = 0;
                        self.summaryContainerView.frame = CGRectMake(0, 0, 320, VOCAVULARY_CELL_HEIGHT);
                        self.summaryLabel.frame = CGRectMake(35, 0, 250, VOCAVULARY_CELL_HEIGHT);
                        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseIn
                            animations:^{
                                self.summaryContainerView.alpha = 1;
                            }
                            completion:^(BOOL finished) {
                                [self performSelector:@selector(removeCell) withObject:nil afterDelay:0.2];
                            }];
                         }
                ];
            }
            else {
                self.clearing = NO;
                self.clearShow = NO;
            }
        }];
}

- (void) removeCell
{
    [MobClick event:EVENT_REMEMBER];
    NSMutableDictionary *orientationData = [[NSMutableDictionary alloc] init];
    [orientationData setValue:self._vocabulary forKey:@"vocabulary"];
    NSNotification *notification = [NSNotification notificationWithName:CLEAR_VOCABULRY object:nil userInfo:orientationData];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    self.clearing = NO;
    self.clearShow = NO;
}

- (void) curlUp:(CGFloat)gestureX
{
    lastGestureX = gestureX;
    if (curlUpTimer != nil) {
        curlUpTimer = nil;
    }
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
        curlUpTimer = nil;
        self.curling = NO;
        self.curlUp = YES;
        self.cellAccessoryImage.hidden = NO;
        self.hadCurlUp = YES;
        [self._vocabulary forgot];
        [self._vocabulary seeSummaryStart];
        [MobClick event:EVENT_FORGET];
        [self scoreDown];
    }
    if (lastGestureX > 260) {
        [curlUpTimer invalidate];
        curlUpTimer = nil;
        self.cellAccessoryImage.hidden = YES;
        self.curling = NO;
    }
}

- (void) scoreDown
{
    self.scoreDownImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ScoreDown"]];
    [self.contentView addSubview:self.scoreDownImage];
	CGRect frame = self.scoreDownImage.frame;
    frame.origin.y = 8;
    self.scoreDownImage.frame = frame;
    frame.origin.y = 28;
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationCurveEaseIn
        animations:^{
            self.scoreDownImage.frame = frame;
            self.scoreDownImage.alpha = 0;
        }
		completion:^(BOOL finished) {
			[self.scoreDownImage removeFromSuperview];
			self.scoreDownImage = nil;
		}
	];
}

- (void) scoreUp
{
    self.scoreUpImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ScoreUp"]];
	[self.contentView addSubview:self.scoreUpImage];
    CGRect frame = self.scoreUpImage.frame;
	frame.origin.x = 280;
    frame.origin.y = 20;
    self.scoreUpImage.frame = frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationCurveEaseIn
        animations:^{
            self.scoreUpImage.frame = frame;
            self.scoreUpImage.alpha = 0;
        }
        completion:^(BOOL finished) {
            [self.scoreUpImage removeFromSuperview];
            self.scoreUpImage = nil;
        }
    ];
}

- (void) doCurlDown
{
    if (self.scoreDownImage != nil) {
        [self.scoreDownImage removeFromSuperview];
        self.scoreDownImage = nil;
    }
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
        curlUpTimer = nil;
        self.curling = NO;
        self.cellAccessoryImage.hidden = NO;
    }
    if (lastGestureX > 260) {
        [curlUpTimer invalidate];
        curlUpTimer = nil;
        self.cellAccessoryImage.hidden = YES;
        self.curlUp = NO;
        self.curling = NO;
        [self._vocabulary finishSummary];
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

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.curlUp = NO;
    self.curling = NO;
    self.clearing = NO;
    self.clearShow = NO;
    self.hadCurlUp = NO;
    self.clearContainer.frame = CGRectMake(0, 0, 0, VOCAVULARY_CELL_HEIGHT);
    self.summaryContainerView.frame = CGRectMake(0, 0, 0, VOCAVULARY_CELL_HEIGHT);
    self.vocabularyContainerView.alpha = 1;
    self.clearContainer.alpha = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
