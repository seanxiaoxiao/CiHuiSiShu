//
//  VSMeaningCell.m
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSMeaningCell.h"
#import "VSConstant.h"

@implementation VSMeaningCell

@synthesize _meanings;
@synthesize meaningView;
@synthesize viewHeight;
@synthesize loaded;

- (void)setMeaningContent:(NSArray *)meanings {
    self._meanings = meanings;
    CGRect meaningViewRect = CGRectMake(0, 0, 320, 392);
    meaningView = [[UIWebView alloc] initWithFrame:meaningViewRect];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *lines = @"";
    for (int i = 0; i < [self._meanings count]; i++) {
        Meaning *meaning = [self._meanings objectAtIndex:i];
        NSString *newLine = [NSString stringWithFormat:MEANINGLINETEMPLATE, meaning.attribute, meaning.meaning];
        lines = [lines stringByAppendingString:newLine];
    }
    NSString *content = [NSString stringWithFormat:MEANINGTEMPLATE, lines];
    [meaningView setDelegate:self];
    [meaningView loadHTMLString:content baseURL:baseURL];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.loaded = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidStartLoad:(UIWebView *)webView {  
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [meaningView sizeToFit];
    [self.contentView addSubview:meaningView];
    [self.contentView sizeToFit];
    viewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"%f", viewHeight);
    self.loaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
@end
