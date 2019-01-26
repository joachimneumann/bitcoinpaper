//
//  ContentViewController.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 04/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize contentWebView;
@synthesize publication;
@synthesize resultNavigationView;

int currentSearchResult = 0;
UIButton *lessButton;
UIButton *moreButton;
UILabel *resultsLabel;
NSString* content;
NSURL *baseURL;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([publication occurrences] > 0) {
        lessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lessButton addTarget:self action:@selector(lessButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lessButton setEnabled:NO];
        [lessButton setTitle:@"<" forState:UIControlStateNormal];
        [lessButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [resultNavigationView addSubview:lessButton];

        moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setTitle:@">" forState:UIControlStateNormal];
        [moreButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [resultNavigationView addSubview:moreButton];
        currentSearchResult = 0;
        [resultNavigationView setHidden:NO];
    } else {
        [resultNavigationView setHidden:YES];
    }
    _searchPos = CGPointZero;
}

- (void)viewDidLayoutSubviews {
    CGRect frame;
    CGRect bounds = self.view.bounds;

    frame = contentWebView.frame;
    frame.origin.y = self.topLayoutGuide.length;
    if ([publication occurrences] > 0) {
        frame.size.height = bounds.size.height - self.topLayoutGuide.length - resultNavigationView.bounds.size.height;
    } else {
        frame.size.height = bounds.size.height - self.topLayoutGuide.length;
    }
    contentWebView.frame = frame;
    
    frame = resultNavigationView.frame;
    frame.origin.y = bounds.size.height - 40;
    frame.size.width = bounds.size.width;
    [resultNavigationView setFrame:frame];
    
    lessButton.frame = CGRectMake(bounds.size.width-80.0, 0.0, 30.0, 40.0);
    moreButton.frame = CGRectMake(bounds.size.width-40.0, 0.0, 30.0, 40.0);
}

- (CGPoint)myPositionOfElementWithId:(NSString *)elementID {
    NSString *js = @"function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
    NSString *result = [contentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementID]];
    CGRect rect = CGRectFromString(result);
    return rect.origin;
}


- (void)lessButtonPressed:(id)sender {
    if (currentSearchResult > 0) {
        NSString *idString = [NSString stringWithFormat:@"searchResultNumber%06i", currentSearchResult-1];
        
        CGPoint offset = [self myPositionOfElementWithId: idString];
        _searchPos.x += offset.x;
        _searchPos.y += offset.y;
        CGPoint p = _searchPos;
        p.x = 0;
        [contentWebView.scrollView setContentOffset:p animated:YES];
        [contentWebView setNeedsLayout];
    } else {
        CGPoint top = CGPointMake(0, 0); // can also use CGPointZero here
        [contentWebView.scrollView setContentOffset:top animated:YES];
    }
    currentSearchResult--;
    if (currentSearchResult < 0) {
        [lessButton setEnabled:NO];
    } else {
        [lessButton setEnabled:YES];
    }
    if (currentSearchResult == [publication occurrences]) {
        [moreButton setEnabled:NO];
    } else {
        [moreButton setEnabled:YES];
    }
}

- (void)moreButtonPressed:(id)sender {
    NSString *idString = [NSString stringWithFormat:@"searchResultNumber%06i", currentSearchResult+1];

    CGPoint offset = [self myPositionOfElementWithId: idString];
    _searchPos.x += offset.x;
    _searchPos.y += offset.y;
    CGPoint p = _searchPos;
    p.x = 0;
    [contentWebView.scrollView setContentOffset:p animated:YES];
    [contentWebView setNeedsLayout];
    currentSearchResult++;
    if (currentSearchResult < 0) {
        [lessButton setEnabled:NO];
    } else {
        [lessButton setEnabled:YES];
    }
    if (currentSearchResult == [publication occurrences]) {
        [moreButton setEnabled:NO];
    } else {
        [moreButton setEnabled:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] bundlePath];
    baseURL = [NSURL fileURLWithPath:path];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int bodyPadding = 0;
    float maxScale = 1.0;
    float fontsize = 16.0;
    if (screenWidth > 400) {
        // e.g., iPad
        bodyPadding = 20;
        maxScale = 1.5;
        fontsize = 20.0;
    }
    NSString* header = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=%5.3f;'><style type='text/css'>html {-webkit-text-size-adjust: none;} ul {-webkit-touch-callout: none; -webkit-user-select: none;} ol, ul {margin-left: 5; padding-left: 10;} dd {margin-left: 0; padding-left: 0;}</style></head>", maxScale];
    NSString* backgroundcolor = @"#ffffff";
    content = [NSString stringWithFormat:@"%@<body style='background-color:%@; margin: %ipx; font-family: helvetica; font-size: %f;'><div style='margin:10px'><i>%@</i></div><div style='margin:10px'>%@</div></body></html>", header, backgroundcolor, bodyPadding, fontsize, [publication published],[publication text]];
    [contentWebView loadHTMLString:content baseURL:baseURL];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // enable selection of text in the html text
    if (action == @selector(copy:)) {
        return true;
    }
    return false;
}

@end
