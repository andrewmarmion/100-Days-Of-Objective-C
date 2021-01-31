//
//  ViewController.m
//  Project6b
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label1 = [[UILabel alloc] init];
    [label1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label1 setBackgroundColor:[UIColor redColor]];
    [label1 setText:@"THESE"];
    [label1 sizeToFit];

    UILabel *label2 = [[UILabel alloc] init];
    [label2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label2 setBackgroundColor:[UIColor cyanColor]];
    [label2 setText:@"ARE"];
    [label2 sizeToFit];

    UILabel *label3 = [[UILabel alloc] init];
    [label3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label3 setBackgroundColor:[UIColor yellowColor]];
    [label3 setText:@"SOME"];
    [label3 sizeToFit];

    UILabel *label4 = [[UILabel alloc] init];
    [label4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label4 setBackgroundColor:[UIColor greenColor]];
    [label4 setText:@"AWESOME"];
    [label4 sizeToFit];

    UILabel *label5 = [[UILabel alloc] init];
    [label5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label5 setBackgroundColor:[UIColor orangeColor]];
    [label5 setText:@"LABELS"];
    [label5 sizeToFit];

    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    [self.view addSubview:label5];

    NSArray<UILabel *> *labels = @[label1, label2, label3, label4, label5];

    // AutoLayout Anchors
    UILabel *previous;
    for (UILabel *label in labels) {
//        [[[label widthAnchor] constraintEqualToAnchor:[self.view widthAnchor]] setActive:YES];
        [[[label leadingAnchor] constraintEqualToAnchor:[[self.view safeAreaLayoutGuide] leadingAnchor]] setActive:YES];
        [[[label trailingAnchor] constraintEqualToAnchor:[[self.view safeAreaLayoutGuide] trailingAnchor]] setActive:YES];
        [[[label heightAnchor] constraintEqualToAnchor:[self.view heightAnchor] multiplier:0.2] setActive:YES];

        if (previous) {
            [[[label topAnchor] constraintEqualToAnchor:[previous bottomAnchor]] setActive:YES];
        } else {
            [[[label topAnchor] constraintEqualToAnchor:[[self.view safeAreaLayoutGuide] topAnchor]] setActive:YES];
        }

        previous = label;
    }

//    // VFL Constraints
//    NSArray<NSString *> *keys = @[@"label1", @"label2", @"label3", @"label4", @"label5"];
//    NSDictionary<NSString *, UILabel *> *viewsDictionary = [[NSDictionary alloc] initWithObjects:labels
//                                                                                         forKeys:keys];
//    // Horizontal Constraints
//    for (NSString *label in keys) {
//        NSString *format = [@"H:|[" stringByAppendingFormat:@"%@]|", label];
//        NSArray<NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
//                                                                                 options:0
//                                                                                 metrics:nil
//                                                                                   views:viewsDictionary];
//        [self.view addConstraints:constraints];
//    }
//
//    // Vertical Constraints
//    NSDictionary<NSString *, id> *verticalMetrics = [[NSDictionary alloc] initWithObjects:@[@88]
//                                                                                 forKeys:@[@"labelHeight"]];
//    NSString *verticalFormat = @"V:|-50-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|";
//    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalFormat
//                                                                                                 options:0
//                                                                                                 metrics:verticalMetrics
//                                                                                                   views:viewsDictionary];
//
//    [self.view addConstraints:verticalConstraints];
}

@end
