//
//  WebViewController.m
//  BranchMonsterFactory
//
//  Created by edward on 9/29/17.
//  Copyright © 2017 Branch. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (nonatomic, strong) IBOutlet WKWebView *webView;
@end

@implementation WebViewController

- (void) setURL:(NSURL *)URL {
    _URL = URL;
    [self updateWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView removeFromSuperview];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self updateWebView];
    self.navigationItem.title = @"Web";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void) updateWebView {
    if (!self.URL) {
        // TODO: Load 'No url' page.
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
