//
//  ViewController.m
//  Project5
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "ViewController.h"
#import "NSArray+Random.h"

@interface ViewController ()

@property (nonatomic) NSArray *allWords;
@property (nonatomic) NSMutableArray *usedWords;

@end

static NSString *CellIdentifier = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up Navigation Items
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(promptForAnswer)];
    [self.navigationItem setRightBarButtonItem:add];

    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                               target:self action:@selector(startGame)];

    [self.navigationItem setLeftBarButtonItem:start];


    // Initialize arrays
    self.usedWords = [[NSMutableArray alloc] init];

    NSString *startWordURL = [[NSBundle mainBundle] pathForResource:@"start" ofType:@"txt"];
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfFile:startWordURL encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        NSLog(@"%@", error);
        return;
    }

    self.allWords = [contents componentsSeparatedByString:@"\n"];

    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:CellIdentifier];

    [self startGame];
}

- (void)startGame
{
    self.title = [self.allWords randomObject];
    [self.usedWords removeAllObjects];
    [self.tableView reloadData];
}

- (void)promptForAnswer
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Enter answer"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Enter your word..."];
    }];

    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"Submit"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        UITextField *answer = ac.textFields.firstObject;
        if(answer.text) {
            [self submitAnswer:answer.text];
        }
    }];

    [ac addAction:submitAction];

    [self presentViewController:ac animated:YES completion:nil];
}

- (void)submitAnswer:(NSString *)answer
{
    NSString * lowerAnswer = [answer lowercaseString];

    if ([self isPossible:lowerAnswer]) {

        if ([self isOriginal:lowerAnswer]) {

            if  ([self isReal:lowerAnswer]) {
                [self.usedWords insertObject:lowerAnswer atIndex:0];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                return;
            } else {
                [self showErrorMessage:@"Word not recognized"
                               message:@"You can't just make them up, you know!"];
            }
        } else {
            [self showErrorMessage:@"Word used already"
                           message:@"Be more original!"];
        }
    } else {
        NSString *title = [self.title lowercaseString];
        if (!title) { return; }
        [self showErrorMessage:@"Word not possible"
                       message:[@"You can't spell that word from " stringByAppendingString:title]];
    }


}

- (void)showErrorMessage:(NSString *)errorTitle message:(NSString *)errorMessage
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:errorTitle
                                                                message:errorMessage
                                                         preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [ac addAction:okAction];

    [self presentViewController:ac animated:YES completion:nil];
}

- (BOOL)isPossible:(NSString *)word
{
    NSString *tempWord = [self.title lowercaseString];
    if (!tempWord) {
        return NO;
    }

    NSMutableArray *answerArray = [self convertToArray:word];
    NSMutableArray *tempWordArray = [self convertToArray:tempWord];

    for (NSString *letter in answerArray) {
        NSUInteger index = [tempWordArray indexOfObject:letter];
        if (index != NSNotFound) {
            [tempWordArray removeObjectAtIndex:index];
        } else {
            return NO;
        }
    }

    return YES;
}

// This it probably not the most efficent way to do this.
-(NSMutableArray *)convertToArray:(NSString *)word
{
    NSUInteger answerLength = [word length];
    NSMutableArray *answerArray = [[NSMutableArray alloc] initWithCapacity:answerLength];

    for (NSUInteger i = 0; i < answerLength; i++) {
        unichar character =[word characterAtIndex:i];
        NSString *letter = [NSString stringWithFormat:@"%C", character];
        [answerArray addObject:letter];
    }
    return answerArray;
}

- (BOOL)isOriginal:(NSString *)word
{
    return ![self.usedWords containsObject:word];
}

- (BOOL)isReal:(NSString *)word
{

    NSUInteger length = [word length];

    if (length < 1) {
        return NO;
    }

    NSString *tempWord = [self.title lowercaseString];
    if ([tempWord isEqual:word]) {
        return NO;
    }

    UITextChecker *checker = [[UITextChecker alloc] init];
    NSRange range = NSMakeRange(0, length);
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word
                                                               range:range
                                                          startingAt:0
                                                                wrap:false
                                                            language:@"en"];

    return misspelledRange.location == NSNotFound;
}


#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usedWords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];

    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSInteger index = [indexPath row];
    NSString *word = [self.usedWords objectAtIndex:index];
    [[cell textLabel] setText:word];

    return cell;
}

@end
