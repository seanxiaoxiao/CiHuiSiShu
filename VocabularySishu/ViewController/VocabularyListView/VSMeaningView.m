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
@synthesize viewHeight;

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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    [self addSubview:meaningView];
    NSLog ( @"Client height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"] );

    viewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('meaning').offsetHeight;"] floatValue];
    NSLog(@"%f", viewHeight);
    [meaningView setFrame:CGRectMake(0, 0, 320, viewHeight + 5)];

    NSNotification *notification = [NSNotification notificationWithName:FINISH_LOADING_MEANING_NOTIFICATION object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
