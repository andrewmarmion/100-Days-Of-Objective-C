//
//  ViewController.m
//  Project8
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "ViewController.h"
#import "NSMutableArray+Shuffling.h"

@interface ViewController ()

@property (nonatomic) UILabel *cluesLabel;
@property (nonatomic) UILabel *answersLabel;
@property (nonatomic) UITextField *currentAnswer;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) NSMutableArray<UIButton *> *letterButtons;
@property (nonatomic) NSMutableArray<NSString *> *solutions;

@property (nonatomic) NSMutableArray<UIButton *> *usedButtons;
@property (nonatomic) NSMutableArray<UIButton *> *currentButtons;

@property (nonatomic) int score;
@property NSInteger level;

@end

@implementation ViewController

- (void)loadView{

    self.letterButtons = [[NSMutableArray alloc] init];
    self.solutions = [[NSMutableArray alloc] init];
    self.usedButtons = [[NSMutableArray alloc] init];
    self.currentButtons = [[NSMutableArray alloc] init];
    self.score = 0;
    self.level = 1;

    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.scoreLabel = [[UILabel alloc] init];
    [self.scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scoreLabel setTextAlignment:NSTextAlignmentRight];
    [self.scoreLabel setText:@"Score: 0"];
    [self.view addSubview:self.scoreLabel];

    self.cluesLabel = [[UILabel alloc] init];
    [self.cluesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cluesLabel setFont:[UIFont systemFontOfSize:24]];
    [self.cluesLabel setText:@"CLUES"];
    [self.cluesLabel setNumberOfLines:0];
    [self.cluesLabel setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisVertical];
    [self.view addSubview:self.cluesLabel];

     self.answersLabel = [[UILabel alloc] init];
    [self.answersLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.answersLabel setFont:[UIFont systemFontOfSize:24]];
    [self.answersLabel setText:@"ANSWERS"];
    [self.answersLabel setNumberOfLines:0];
    [self.answersLabel setTextAlignment:NSTextAlignmentRight];
    [self.answersLabel setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisVertical];
    [self.view addSubview:self.answersLabel];


    self.currentAnswer = [[UITextField alloc] init];
    [self.currentAnswer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.currentAnswer setPlaceholder:@"Tap letters to guess"];
    [self.currentAnswer setTextAlignment:NSTextAlignmentRight];
    [self.currentAnswer setFont:[UIFont systemFontOfSize:44]];
    [self.currentAnswer setUserInteractionEnabled:NO];
    [self.view addSubview:self.currentAnswer];

    UIButton *submit = [UIButton buttonWithType:UIButtonTypeSystem];
    [submit setTranslatesAutoresizingMaskIntoConstraints:NO];
    [submit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];

    UIButton *clear = [UIButton buttonWithType:UIButtonTypeSystem];
    [clear setTranslatesAutoresizingMaskIntoConstraints:NO];
    [clear setTitle:@"CLEAR" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clear];

    UIView *buttonsView = [[UIView alloc] init];
    [buttonsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:buttonsView];


    // Set constraints
    UILayoutGuide *layoutMarginsGuide = [self.view layoutMarginsGuide];
    [[[self.scoreLabel topAnchor] constraintEqualToAnchor:[layoutMarginsGuide topAnchor]] setActive:YES];
    [[[self.scoreLabel trailingAnchor] constraintEqualToAnchor:[layoutMarginsGuide trailingAnchor]] setActive:YES];

    [[[self.cluesLabel topAnchor] constraintEqualToAnchor:[self.scoreLabel bottomAnchor]] setActive:YES];
    [[[self.cluesLabel leadingAnchor] constraintEqualToAnchor:[layoutMarginsGuide leadingAnchor] constant:100] setActive:YES];
    [[[self.cluesLabel widthAnchor] constraintEqualToAnchor:[layoutMarginsGuide widthAnchor] multiplier:0.6 constant: -100] setActive:YES];

    [[[self.answersLabel topAnchor] constraintEqualToAnchor:[self.scoreLabel bottomAnchor]] setActive:YES];
    [[[self.answersLabel trailingAnchor] constraintEqualToAnchor:[layoutMarginsGuide trailingAnchor] constant:-100] setActive:YES];
    [[[self.answersLabel widthAnchor] constraintEqualToAnchor:[layoutMarginsGuide widthAnchor] multiplier:0.4 constant:-100] setActive:YES];
    [[[self.answersLabel heightAnchor] constraintEqualToAnchor:[self.cluesLabel heightAnchor]] setActive:YES];

    [[[self.currentAnswer centerXAnchor] constraintEqualToAnchor:[self.view centerXAnchor]] setActive:YES];
//    [[[self.currentAnswer widthAnchor] constraintEqualToAnchor:[self.view widthAnchor] multiplier:0.5] setActive:YES];
    [[[self.currentAnswer topAnchor] constraintEqualToAnchor:[self.cluesLabel bottomAnchor] constant:20] setActive:YES];

    [[[submit topAnchor] constraintEqualToAnchor:[self.currentAnswer bottomAnchor]] setActive:YES];
    [[[submit centerXAnchor] constraintEqualToAnchor:[self.view centerXAnchor] constant:-100] setActive:YES];
    [[[submit heightAnchor] constraintEqualToConstant:44] setActive:YES];

    [[[clear centerXAnchor] constraintEqualToAnchor:[self.view centerXAnchor] constant:100] setActive:YES];
    [[[clear centerYAnchor] constraintEqualToAnchor:[submit centerYAnchor]] setActive:YES];
    [[[clear heightAnchor] constraintEqualToConstant:44] setActive:YES];

    [[[buttonsView widthAnchor] constraintEqualToConstant:750] setActive:YES];
    [[[buttonsView heightAnchor] constraintEqualToConstant:320] setActive:YES];
    [[[buttonsView centerXAnchor] constraintEqualToAnchor:[self.view centerXAnchor]] setActive:YES];
    [[[buttonsView topAnchor] constraintEqualToAnchor:[submit bottomAnchor] constant:20] setActive:YES];
    [[[buttonsView bottomAnchor] constraintEqualToAnchor:[layoutMarginsGuide bottomAnchor] constant:-20] setActive:YES];

    [[buttonsView layer] setBorderWidth:1];
    [[buttonsView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[buttonsView layer] setCornerRadius:20];

    CGFloat width = 150;
    CGFloat height = 80;

    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 5; col++) {
            UIButton *letterButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [[letterButton titleLabel] setFont:[UIFont systemFontOfSize:36]];
            [letterButton setTitle:@"WWW" forState:UIControlStateNormal];

            CGRect frame = CGRectMake(col * width, row * height, width, height);
            [letterButton setFrame:frame];
            [letterButton addTarget:self action:@selector(letterTapped:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsView addSubview:letterButton];

            [self.letterButtons addObject:letterButton];
        }
    }

    [self loadLevel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadLevel
{
    NSString *clueString = @"";
    NSString *solutionString = @"";
    NSMutableArray<NSString *> *letterBits = [[NSMutableArray alloc] init];

    NSURL *levelFileURL = [[NSBundle mainBundle] URLForResource:@"level1" withExtension:@"txt"];
    if (levelFileURL) {
        NSError *error;
        NSString *levelContents = [NSString stringWithContentsOfURL:levelFileURL encoding:NSUTF8StringEncoding error:&error];

        if (error) {
            NSLog(@"%@", error);
            return;
        }

        NSMutableArray<NSString *> *lines = [[levelContents componentsSeparatedByString:@"\n"] mutableCopy];
        [lines shuffle];

        int length = (int)[lines count];
        for (int index = 0; index < length; index++) {
            NSString *line = lines[index];
            NSArray *parts = [line componentsSeparatedByString:@": "];
            NSString *answer = parts[0];
            NSString *clue = parts[1];

            clueString = [clueString stringByAppendingFormat:@"%d. %@\n", index + 1, clue];

            NSString *solutionWord = [answer stringByReplacingOccurrencesOfString:@"|" withString:@""];
            solutionString = [solutionString stringByAppendingFormat:@"%d letters\n", (int)[solutionWord length]];
            [self.solutions addObject:solutionWord];

            NSArray<NSString *> *bits = [answer componentsSeparatedByString:@"|"];
            [letterBits addObjectsFromArray:bits];
        }

        NSCharacterSet *whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        self.cluesLabel.text = [clueString stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];
        self.answersLabel.text = [solutionString stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];

        //shuffle letterbits
        [letterBits shuffle];
        NSUInteger letterBitsCount = [letterBits count];
        NSUInteger letterButtonsCount = [self.letterButtons count];

        if (letterBitsCount == letterButtonsCount) {
            for (int i = 0; i < letterButtonsCount; i++) {
                [self.letterButtons[i] setTitle:letterBits[i] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setScore:(int)score
{
    _score = score;
    self.scoreLabel.text = [@"Score: " stringByAppendingFormat:@"%d", score];
}

#pragma mark - Selectors

- (void)letterTapped:(UIButton *)sender
{
    NSString *buttonTitle = sender.titleLabel.text;
    if (buttonTitle) {
        self.currentAnswer.text = [self.currentAnswer.text stringByAppendingString:buttonTitle];
        [self.currentButtons addObject:sender];
        [sender setHidden:YES];
    }
}

- (void)clearTapped:(UIButton *)sender
{
    self.currentAnswer.text = @"";

    for (UIButton *button in self.currentButtons) {
        button.hidden = false;
    }

    [self.currentButtons removeAllObjects];
}


- (void)submitTapped:(UIButton *)sender
{
    NSString *answerText = self.currentAnswer.text;
    if (answerText) {
        NSUInteger solutionPosition = [self.solutions indexOfObject:answerText];

        if (solutionPosition != NSNotFound) {
            NSMutableArray *splitAnswers = [[self.answersLabel.text componentsSeparatedByString:@"\n"] mutableCopy];
            if ([splitAnswers count] > 0) {
                splitAnswers[solutionPosition] = answerText;

                self.answersLabel.text = [splitAnswers componentsJoinedByString:@"\n"];
                self.currentAnswer.text = @"";
                self.score += 1;

                [self.usedButtons addObjectsFromArray:self.currentButtons];
                [self.currentButtons removeAllObjects];

                NSUInteger correct = [self.usedButtons count];
                if (correct == 20) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Well done!"
                                                                                message:@"Are you ready for the next level?"
                                                                         preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Let's go!"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                        [self levelUp];
                    }];

                    [ac addAction:okAction];
                    [self presentViewController:ac animated:YES completion:nil];
                }
            }
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Ooops"
                                                                        message:@"That's not right!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                self.score -= 1;
            }];

            [ac addAction:okAction];

            [self presentViewController:ac animated:YES completion:nil];
        }
    }
}

- (void)levelUp
{
    self.level += 1;
    [self.solutions removeAllObjects];
    [self.currentButtons removeAllObjects];
    [self.usedButtons removeAllObjects];

    [self loadLevel];

    for (UIButton *button in self.letterButtons) {
        [button setHidden:NO];
    }
}

@end
