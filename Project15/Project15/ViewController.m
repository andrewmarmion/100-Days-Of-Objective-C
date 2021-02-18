//
//  ViewController.m
//  Project15
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) int currentAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentAnimation = 0;
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penguin"]];
    self.imageView.center = [self.view center];
    [self.view addSubview:self.imageView];
}

- (IBAction)tapped:(UIButton *)sender {
    [sender setHidden:YES];

    [UIView animateWithDuration:1
                          delay:0
          usingSpringWithDamping:0.5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        switch(self.currentAnimation) {

            case 0:
                [self.imageView setTransform:CGAffineTransformMakeScale(2, 2)];
                break;
            case 1:
                [self.imageView setTransform:CGAffineTransformIdentity];
                break;

            case 2:
                [self.imageView setTransform:CGAffineTransformMakeTranslation(-256, -256)];
                break;
            case 3:
                [self.imageView setTransform:CGAffineTransformIdentity];
                break;

            case 4:
                [self.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                break;
            case 5:
                [self.imageView setTransform:CGAffineTransformIdentity];
                break;

            case 6:
                [self.imageView setAlpha:0.1];
                [self.imageView setBackgroundColor:[UIColor greenColor]];
                break;
            case 7:
                [self.imageView setAlpha:1];
                [self.imageView setBackgroundColor:[UIColor clearColor]];
                break;

            default:
                break;
        }
    } completion:^(BOOL finished) {
        [sender setHidden:NO];
    }];

    self.currentAnimation += 1;
    if (self.currentAnimation > 7) {
        self.currentAnimation = 0;
    }
}

@end
