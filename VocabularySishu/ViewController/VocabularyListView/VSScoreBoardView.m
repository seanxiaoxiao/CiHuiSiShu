//
//  VSScoreBoardView.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSScoreBoardView.h"

@implementation VSScoreBoardView

@synthesize scoreBoardBackground;
@synthesize retryButton;
@synthesize nextButton;
@synthesize backButton;
@synthesize notWellLabel;
@synthesize notWellRateLabel;
@synthesize _list;
@synthesize notRememberWell;
@synthesize notRememberWellStep;
@synthesize numberFormatter;
@synthesize notRememberWellTimer;
@synthesize notRememberWellInList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.scoreBoardBackground = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"ScoreBoardPopup"]];
        [self addSubview:scoreBoardBackground];
        [self sendSubviewToBack:scoreBoardBackground];
        
        self.notWellLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, 70, 30)];
        self.notWellLabel.text = @"靠谱";
        self.notWellLabel.font = [UIFont boldSystemFontOfSize:18];
        self.notWellLabel.backgroundColor = [UIColor clearColor];
        self.notWellLabel.textAlignment = UITextAlignmentLeft;
        self.notWellLabel.textColor = [UIColor whiteColor];
        self.notWellLabel.alpha = 0.9;
        self.notWellLabel.shadowOffset = CGSizeMake(0, -1);
        self.notWellLabel.shadowColor = [UIColor blackColor];

        self.notWellRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 73, 120, 30)];
        self.notWellRateLabel.text = @"-";
        self.notWellRateLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30];
        self.notWellRateLabel.backgroundColor = [UIColor clearColor];
        self.notWellRateLabel.textAlignment = UITextAlignmentRight;
        self.notWellRateLabel.textColor = [UIColor whiteColor];
        self.notWellRateLabel.alpha = 0.9;
        self.notWellRateLabel.shadowOffset = CGSizeMake(0, -1);
        self.notWellRateLabel.shadowColor = [UIColor blackColor];

        [self addSubview:notWellLabel];
        [self addSubview:notWellRateLabel];
        
        UIImage *closeButtonImage = [VSUtils fetchImg:@"PopupClose"];
        UIImage *highlightCloseButtonImage = [VSUtils fetchImg:@"PopupCloseHighLighted"];
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(165, 5, closeButtonImage.size.width, closeButtonImage.size.height)];
        [self.closeButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
        [self.closeButton setBackgroundImage:highlightCloseButtonImage forState:UIControlStateHighlighted];
        [self.closeButton addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        self.notRememberWell = 1.0;
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"0.0%;0.0%-0.0%"];
        
        
    }
    return self;
}

- (void)retry
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    navigationController.navigationBar.userInteractionEnabled = YES;

    NSNotification *notification = [NSNotification notificationWithName:RESTART_LIST object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)next
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    navigationController.navigationBar.userInteractionEnabled = YES;

    NSNotification *notification = [NSNotification notificationWithName:NEXT_LIST object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)backToMain
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [navigationController popToRootViewControllerAnimated:YES];
    navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)closePopup
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    navigationController.navigationBar.userInteractionEnabled = YES;

    NSNotification *notification = [NSNotification notificationWithName:CLOSE_POPUP object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];    
}

- (void)initWithList:(VSList *)list
{
    self._list = list;
    self.notRememberWellInList = [self._list rememberRate];
    notRememberWellStep = (1.01 - self.notRememberWellInList) / 20;
    self.notRememberWellTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateNotRememberWell) userInfo:nil repeats:YES];
}

- (void)showButtons
{
    UIImage *normalButtonImage = [VSUtils fetchImg:@"ButtonBT"];
    UIImage *highlightButtonImage = [VSUtils fetchImg:@"ButtonBTHighLighted"];
    
    self.retryButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 125, normalButtonImage.size.width, normalButtonImage.size.height)];
    [self.retryButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
    [self.retryButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
    [self.retryButton setTitle:@"重新背诵" forState:UIControlStateNormal];
    [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.retryButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.retryButton.titleLabel.shadowColor = [UIColor blackColor];
    
    [self addSubview:retryButton];
    
    if ([self._list isHistoryList]) {
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 125, normalButtonImage.size.width, normalButtonImage.size.height)];
        [self.backButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.backButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.backButton.titleLabel.shadowColor = [UIColor blackColor];
        self.backButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:backButton];
    }
    else {
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 125, normalButtonImage.size.width, normalButtonImage.size.height)];
        [self.nextButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
        [self.nextButton setBackgroundImage:highlightButtonImage forState:UIControlStateHighlighted];
        [self.nextButton setTitle:@"下个列表" forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.nextButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.nextButton.titleLabel.shadowColor = [UIColor blackColor];
        [self addSubview:nextButton];
    }
}


- (void)updateNotRememberWell
{
    self.notRememberWell -= notRememberWellStep;
    if (self.notRememberWell < self.notRememberWellInList) {
        self.notRememberWell = self.notRememberWellInList;
        [self.notRememberWellTimer invalidate];
        self.notRememberWellTimer = nil;
        
        int starCount = self.notRememberWellInList / 0.33;
        int originX = 54;

        for (int i = 0; i < starCount; i++) {
            UIImageView *starImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"Star"]];
            starImage.frame = CGRectMake(originX, 12, starImage.image.size.width, starImage.image.size.height);
            originX += starImage.image.size.width + 5;
            CGRect originalFrame = starImage.frame;
            CGRect enlargedFrame = CGRectMake(originalFrame.origin.x - 5, originalFrame.origin.y - 5, originalFrame.size.width + 10, originalFrame.size.height + 10);
            [self addSubview:starImage];
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveLinear
                             animations:^{
                                 starImage.frame = enlargedFrame;
                             }
                             completion:^(BOOL finished) {
                                 if (finished == YES) {
                                     [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveLinear
                                                      animations:^{
                                                          starImage.frame = originalFrame;
                                                      }
                                                      completion:^(BOOL finished) {
                                                      }
                                      ];
                                 }
                             }
             ];
        }
        for (int i = 0 ; i < 3 - starCount; i++) {
            UIImageView *noStarImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"StarNone"]];
            noStarImage.frame = CGRectMake(originX, 12, noStarImage.image.size.width, noStarImage.image.size.height);
            originX += noStarImage.image.size.width + 5;
            [self addSubview:noStarImage];
        }
        [self showButtons];
    }
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.notRememberWell]];
    self.notWellRateLabel.text = formattedNumberString;
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
