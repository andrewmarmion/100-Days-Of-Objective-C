//
//  ViewController.m
//  Project4
//
//  Created by Andrew Marmion on 30/01/2021.
//

#import "ViewController.h"

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIProgressView *progressView;
@property (nonatomic) NSArray *websites;

@property (nonatomic) UIBarButtonItem *forward;
@property (nonatomic) UIBarButtonItem *back;
@end

@implementation ViewController

- (void)loadView
{
    // Setup Webview
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.websites = @[@"apple.com", @"hackingwithswift.com"];


    // Load url
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.hackingwithswift.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setAllowsBackForwardNavigationGestures:YES];

    // Setup barbuttons
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Open"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(openTapped)];

    [self.navigationItem setRightBarButtonItem:item];

    // Set up toolbar

    UIImage *forwardImage = [UIImage systemImageNamed:@"chevron.right"];
    self.forward = [[UIBarButtonItem alloc] initWithImage:forwardImage
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(goForward)];

    UIImage *backImage = [UIImage systemImageNamed:@"chevron.left"];
    self.back = [[UIBarButtonItem alloc] initWithImage:backImage
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(goBack)];

    self.forward.enabled = NO;
    self.back.enabled = NO;

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView sizeToFit];
    UIBarButtonItem *progress = [[UIBarButtonItem alloc] initWithCustomView:self.progressView];

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                             target:self
                                                                             action:@selector(reloadWebview)];



    self.toolbarItems = @[self.back, self.forward, progress, spacer, refresh];
    [self.navigationController setToolbarHidden:NO];


    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)goForward
{
    [self.webView goForward];
}

- (void)goBack
{
    [self.webView goBack];
}

- (void)reloadWebview
{
    [self.webView reload];
}

- (void)openTapped
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Open page..."
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSString *website in self.websites) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:website
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
            NSString *title = [action title];
            [self openPage:title];
        }];
        [ac addAction:action];
    }


    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [ac addAction:cancelAction];

    [[ac popoverPresentationController] setBarButtonItem:self.navigationItem.rightBarButtonItem];

    [self presentViewController:ac animated:YES completion:nil];
}

- (void)openPage:(NSString *)title
{
    NSString *urlString = [@"https://" stringByAppendingFormat:@"%@", title];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual: @"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.title = webView.title;
    self.forward.enabled = [webView canGoForward];
    self.back.enabled = [webView canGoBack];


}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = [navigationAction request].URL;

    NSString *host = [url host];
    if (host) {
        for (NSString *website in self.websites) {
            if([host containsString:website]) {
                decisionHandler(WKNavigationActionPolicyAllow);
                return;
            }
        }
    }
    NSString *message = [@"The following website is not allowed\n" stringByAppendingFormat:@"%@", host];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Forbidden"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];

    decisionHandler(WKNavigationActionPolicyCancel);
}

@end
