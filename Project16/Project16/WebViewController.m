//
//  WebViewController.m
//  Project16
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic) WKWebView *webView;
@end

@implementation WebViewController

- (void)loadView
{
    // Setup Webview
    self.webView = [[WKWebView alloc] init];
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

@end
