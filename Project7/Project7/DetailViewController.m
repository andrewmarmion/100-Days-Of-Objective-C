//
//  DetailViewController.m
//  Project7
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "DetailViewController.h"
#import "Petition.h"

@interface DetailViewController ()

@property (nonatomic) WKWebView *webView; 

@end

@implementation DetailViewController

- (void)loadView
{
    self.webView = [[WKWebView alloc] init];
    self.view = self.webView;

    if (self.petition) {
        NSString *html = [@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style> body { font-size: 150%; } </style></head><body>" stringByAppendingFormat:@"%@</body></html>", self.petition.body];

        [self.webView loadHTMLString:html baseURL:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
