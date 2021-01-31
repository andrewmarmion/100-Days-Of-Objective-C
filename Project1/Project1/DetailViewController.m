//
//  DetailViewController.m
//  Project1
//
//  Created by Andrew Marmion on 30/01/2021.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.selectedImage) {
        UIImage *image = [UIImage imageNamed:self.selectedImage];
        [self.imageView setImage:image];
    }

    self.title = self.titleString;
    [self.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setHidesBarsOnTap:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setHidesBarsOnTap:NO];
}

@end
