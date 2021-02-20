//
//  ViewController.m
//  Project18
//
//  Created by Andrew Marmion on 20/02/2021.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Printing a string/object
    NSLog(@"%@", @"I am inside the viewDidLoad() method.");

    // Printing integers
    NSLog(@"%d - %d - %d - %d - %d", 1, 2, 3, 4, 5);

    // Printing without linebreaks
    printf("hello");
    printf("hello");
    printf("hello");


    for (int i = 1; i <= 100; i++) {
        NSLog(@"Got number %d", i);
    }

    NSAssert(1 == 1, @"Math failure!");
    NSAssert(1 == 2, @"Math failure!"); // This is fail and crash the app, though only in debug builds




}


@end
