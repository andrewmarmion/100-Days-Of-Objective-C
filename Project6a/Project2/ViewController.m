//
//  ViewController.m
//  Project2
//
//  Created by Andrew Marmion on 30/01/2021.
//

#import "ViewController.h"
#import "NSMutableArray+Shuffling.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (strong) NSMutableArray *countries;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger correctAnswer;
@property (nonatomic) NSInteger questionsAsked;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.countries = [[NSMutableArray alloc] init];

    [self.countries addObject:@"estonia"];
    [self.countries addObject:@"france"];
    [self.countries addObject:@"germany"];
    [self.countries addObject:@"ireland"];
    [self.countries addObject:@"italy"];
    [self.countries addObject:@"monaco"];
    [self.countries addObject:@"nigeria"];
    [self.countries addObject:@"poland"];
    [self.countries addObject:@"russia"];
    [self.countries addObject:@"spain"];
    [self.countries addObject:@"uk"];
    [self.countries addObject:@"us"];


    [self configureButton:self.button1 tag:0];
    [self configureButton:self.button2 tag:1];
    [self configureButton:self.button3 tag:2];

    [self beginNewRound];
}

- (void)configureButton:(UIButton *)button tag:(NSInteger)tag
{
    [[button layer] setBorderWidth:1];
    [[button layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[button layer] setCornerRadius:20];
    [[button layer] setMasksToBounds:YES];
    [button setTag:tag];
}

- (void)askQuestion
{
    [self.countries shuffle];
    self.correctAnswer = arc4random_uniform(3);
    self.title = [self.countries[self.correctAnswer] uppercaseString];
    self.questionsAsked = self.questionsAsked + 1;


    UIImage *image1 = [UIImage imageNamed:self.countries[0]];
    UIImage *image2 = [UIImage imageNamed:self.countries[1]];
    UIImage *image3 = [UIImage imageNamed:self.countries[2]];

    [UIView transitionWithView:self.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        [self.button1 setImage:image1
                      forState:UIControlStateNormal];

        [self.button2 setImage:image2
                     forState:UIControlStateNormal];


        [self.button3 setImage:image3
                     forState:UIControlStateNormal];
    }
                    completion:nil];
}

- (void)beginNewRound
{
    self.score = 0;
    self.questionsAsked = 0;

    [self askQuestion];
}

- (void)setScore:(NSInteger)score
{
    _score = score;

    NSString *scoreString = [@"" stringByAppendingFormat:@"%ld", score];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:scoreString menu:nil];
    item.enabled = NO;
    [[self navigationItem] setRightBarButtonItem:item];

}

#pragma mark - IBActions

- (IBAction)buttonTapped:(UIButton *)sender {

    NSString *title;
    NSString *message;

    NSInteger tag = [sender tag];

    if (tag == self.correctAnswer) {
        self.score += 1;
        title =  @"Correct";
        message = [@"Your score is " stringByAppendingFormat:@"%ld.", self.score];

    } else {
        self.score -= 1;
        title = @"Wrong";
        NSString *wrongFlag = self.countries[tag];
        message = [@"That was the flag of " stringByAppendingFormat:@"%@.", wrongFlag];
    }



    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    if (self.questionsAsked < 10) {
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
            [self askQuestion];
        }];
        [alert addAction:continueAction];
    } else {

        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Play again"
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * _Nonnull action) {
            [self beginNewRound];
        }];
        [alert addAction:continueAction];
    }


    [self presentViewController:alert animated:YES completion:nil];

}

@end
