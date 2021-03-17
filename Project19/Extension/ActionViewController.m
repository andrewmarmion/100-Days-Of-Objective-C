//
//  ActionViewController.m
//  Extension
//
//  Created by Andrew Marmion on 17/03/2021.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(nonatomic, copy) NSString *pageTitle;
@property(nonatomic, copy) NSString *pageURL;
@property (weak, nonatomic) IBOutlet UITextView *script;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(done)];
    [self.navigationItem setRightBarButtonItem:done];

    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(adjustForKeyboard:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(adjustForKeyboard:)
                               name:UIKeyboardWillChangeFrameNotification
                             object:nil];

    NSExtensionItem *item = [self.extensionContext.inputItems firstObject];
    if (item) {
        NSItemProvider *itemProvider = [item.attachments firstObject];
        if (itemProvider) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList
                                                options:nil
                                      completionHandler:^(__kindof id<NSSecureCoding>  _Nullable dict, NSError *error) {

                    NSDictionary *itemDictionary = (NSDictionary *)dict;
                    if (itemDictionary) {
                        NSDictionary *javaScriptValues = (NSDictionary *)itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey];
                        if (javaScriptValues) {

                            self.pageTitle = (NSString *)javaScriptValues[@"title"];
                            self.pageURL = (NSString *)javaScriptValues[@"URL"];

                            NSLog(@"%@", self.pageTitle);
                            NSLog(@"%@", self.pageURL);

                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                self.title = self.pageTitle;
                            }];
                        }
                    }

                }];

            }
        }
    }
}

- (IBAction)done {

    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    NSDictionary *argument = @{@"customJavaScript": self.script.text};
    NSDictionary *webDictionary = @{NSExtensionJavaScriptFinalizeArgumentKey: argument};
    NSItemProvider *customJavaScript = [[NSItemProvider alloc] initWithItem:webDictionary
                                                             typeIdentifier:(NSString *)kUTTypePropertyList];
    [item setAttachments:@[customJavaScript]];

    [self.extensionContext completeRequestReturningItems:@[item] completionHandler:nil];
}

- (void)adjustForKeyboard:(NSNotification *)notification
{
    NSLog(@"%@", notification);

    NSValue *keyboardValue = (NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardScreenEndFrame = keyboardValue.CGRectValue;

    CGRect keyboardViewEndFrame = [self.view convertRect:keyboardScreenEndFrame
                                                  toView:self.view.window];

    if ([notification.name isEqual:UIKeyboardWillHideNotification]) {
        self.script.contentInset = UIEdgeInsetsZero;
    } else {
        self.script.contentInset = UIEdgeInsetsMake(0, 0, keyboardViewEndFrame.size.height - self.view.safeAreaInsets.bottom, 0);
    }

    self.script.scrollIndicatorInsets = self.script.contentInset;

    NSRange selectedRange = self.script.selectedRange;
    [self.script scrollRangeToVisible:selectedRange];
}

@end
