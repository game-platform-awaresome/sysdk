//
//  m185WebViewController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/10/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "m185WebViewController.h"

@interface m185WebViewController ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate,UIAlertViewDelegate>

/** title */
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *lineView;

/** 网页 */
@property (nonatomic, strong) WKWebView *webView;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation m185WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.titleView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 64);
    self.titleLabel.frame = CGRectMake(0, 10, kSCREEN_WIDTH, 54);
    self.closeButton.frame = CGRectMake(kSCREEN_WIDTH - 40, 27, 30, 30);
    self.lineView.frame = CGRectMake(0, 62, kSCREEN_WIDTH, 2);
    self.progressView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, 3);
    self.webView.frame = CGRectMake(0, 67, kSCREEN_WIDTH, kSCREEN_HEIGHT - 67);
}

#pragma method -
- (void)closeWebView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185WebViewController:closeWebViewWith:)]) {
        [self.delegate m185WebViewController:self closeWebViewWith:nil];
    }
}



#pragma mark - UIWebViewDelegate
- (void)addWebViewWithUrl:(NSString *)url {
    NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
}

#pragma mark - web view delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    [webView loadRequest:navigationAction.request];

    return nil;
}

// API是根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest * request = navigationAction.request;

    NSURL * url = [request URL];
    WKNavigationActionPolicy  actionPolicy = WKNavigationActionPolicyAllow;

    if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {

    } else {
        [[UIApplication sharedApplication] openURL:url];
    }


    decisionHandler(actionPolicy);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


#pragma mark - getter
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
        _titleView.backgroundColor = RGBCOLOR(222, 222, 222);
        [_titleView addSubview:self.titleLabel];
        [_titleView addSubview:self.closeButton];
//        [_titleView addSubview:self.lineView];
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 54)];
        _titleLabel.text = @"充值";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeButton.frame = CGRectMake(kSCREEN_WIDTH - 60, 27, 30, 30);
        [_closeButton setImage:SDK_IMAGE(@"SYSDK_closeButton") forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeWebView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, kSCREEN_WIDTH, 2)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 67, kSCREEN_WIDTH, kSCREEN_HEIGHT - 67)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 3)];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.backgroundColor = [UIColor lightGrayColor];
    }
    return _progressView;
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}



@end












