//
//  WebViewController.m
//  BranchMonsterFactory
//
//  Created by edward on 9/29/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import "WebViewController.h"
@import WebKit;

@interface WebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) IBOutlet WKWebView *webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation WebViewController

- (void) setURL:(NSURL *)URL {
    _URL = URL;
    [self updateWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Web";
    [self.webView removeFromSuperview];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self updateWebView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self hideActivityView];
}

#pragma mark - Web View Methods

- (void) updateWebView {
    if (!self.URL) {
        [self showErrorMessage:@"No URL to load!"];
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self showActivityView];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView
didFailNavigation:(WKNavigation *)navigation
        withError:(NSError *)error {
    [self showErrorMessage:[NSString stringWithFormat:@"Can't navigate to<br>'%@'.", self.webView.URL]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideActivityView];
    self.navigationItem.title = self.webView.title;
}

- (void) showActivityView {
    [self.activityIndicatorView startAnimating];
    [self.view.window addSubview:self.activityIndicatorView];
}

- (void) hideActivityView {
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
}

- (void) showErrorMessage:(NSString*)message {
    NSString *errorPage = NSLocalizedStringFromTableInBundle(
        @"WebErrorPage",
        @"Strings",
        [NSBundle bundleForClass:self.class],
        @""
    );
    errorPage = [NSString stringWithFormat:errorPage, message];
    [self.webView loadHTMLString:errorPage baseURL:nil];
}

@end
