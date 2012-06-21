//
//  VSMeaningView.m
//  VocabularySishu
//
//  Created by xiao xiao on 6/18/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSMeaningView.h"
#import "VSConstant.h"

@implementation VSMeaningView

@synthesize _meanings;
@synthesize meaningView;
@synthesize detailButton;
@synthesize viewHeight;
@synthesize meaningFor;

- (void)setMeaningContent:(NSArray *)meanings {
    self._meanings = meanings;
    CGRect meaningViewRect = CGRectMake(0, 0, 320, 392);
    meaningView = [[UIWebView alloc] initWithFrame:meaningViewRect];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *lines = @"";
    for (int i = 0; i < [self._meanings count]; i++) {
        VSMeaning *meaning = [self._meanings objectAtIndex:i];
        NSString *newLine = [NSString stringWithFormat:MEANINGLINETEMPLATE, meaning.attribute, meaning.meaning];
        lines = [lines stringByAppendingString:newLine];
    }
    NSString *content = [NSString stringWithFormat:MEANINGTEMPLATE, lines];
    [meaningView setDelegate:self];
    [meaningView loadHTMLString:content baseURL:baseURL];
    meaningView.scrollView.scrollEnabled = NO;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIView *viewForButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    viewForButton.backgroundColor = [UIColor whiteColor];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    but.frame= CGRectMake(30, 0, 60, 30);
    [but setTitle:@"详细" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [viewForButton addSubview:but];
    viewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('meaning').offsetHeight;"] floatValue];
    [meaningView setFrame:CGRectMake(0, 30, 320, viewHeight + 5)];
    [self.contentView addSubview:viewForButton];
    [self.contentView addSubview:meaningView];
    viewHeight = viewHeight + 50;
    [self.contentView sizeToFit];

    NSNotification *notification = [NSNotification notificationWithName:FINISH_LOADING_MEANING_NOTIFICATION object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)showDetail
{
    NSNotification *notification = [NSNotification notificationWithName:SHOW_DETAIL_VIEW object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
