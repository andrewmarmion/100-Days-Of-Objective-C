//
//  ViewController.m
//  Project7
//
//  Created by Andrew Marmion on 31/01/2021.
//


#import "ViewController.h"

#import "DetailViewController.h"
#import "Petition.h"

@interface ViewController ()

@property (nonatomic) NSMutableArray *petitions;
@property (nonatomic) NSMutableArray *filteredPetitions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *credits = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                             target:self
                                                                             action:@selector(showCredits)];

    [self.navigationItem setRightBarButtonItem:credits];

    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                             target:self
                                                                             action:@selector(searchAlert)];

    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                             target:self
                                                                             action:@selector(refresh)];

    [self.navigationItem setLeftBarButtonItems:@[search, reload]];


    // Setup array
    self.petitions = [[NSMutableArray alloc] init];
    self.filteredPetitions = [[NSMutableArray alloc] init];

    // Get data from API
    NSString *urlString;

    if (self.navigationController.tabBarItem.tag == 0) {
        urlString = @"https://www.hackingwithswift.com/samples/petitions-1.json";
        UIImage *image = [UIImage systemImageNamed:@"list.bullet"];
        self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Petitions"
                                                                             image:image
                                                                               tag:0];
    } else {
        urlString = @"https://www.hackingwithswift.com/samples/petitions-2.json";
    }

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *dataError;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&dataError];

        if (dataError) {
            [self performSelectorOnMainThread:@selector(showError) withObject:nil waitUntilDone:NO];
        } else {
            [self parseJSON:data];
        }
    });

}

- (void)parseJSON:(NSData *)data
{
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&error];
    if (error) {
        NSLog(@"%@", error);
        [self showError];
        return;
    }

    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *result = object;
        NSArray *petitions = result[@"results"];

        for(NSDictionary *petition in petitions) {
            NSString *title = petition[@"title"];
            NSString *body = petition[@"body"];
            NSNumber *signatureCount = petition[@"signatureCount"];

            if (title != nil && body != nil && signatureCount != nil) {
                Petition *newPetition = [[Petition alloc] init];
                [newPetition setTitle:title];
                [newPetition setBody:body];
                [newPetition setSignatureCount:signatureCount];

                [self.petitions addObject:newPetition];
                [self.filteredPetitions addObject:newPetition];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } else {
        [self performSelectorOnMainThread:@selector(showError) withObject:nil waitUntilDone:NO];
    }
}

- (void)refresh
{
    [self.filteredPetitions addObjectsFromArray:self.petitions];
    [self.tableView reloadData];
}

- (void)searchAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Search for..."
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];

    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Enter your search term"];
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {

        UITextField *search = ac.textFields.firstObject;
        [self.filteredPetitions removeAllObjects];
        NSString *searchText = [search.text copy];

        // Perform filter on Background thread
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            if (searchText) {
                for (Petition *petition in self.petitions) {
                    if ([petition.title containsString:searchText] || [petition.body containsString:searchText]) {
                        [self.filteredPetitions addObject:petition];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });

    }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showCredits
{
    [self showAlert:@"Credits"
            message:@"The data comes from the\nWe The People API of the Whitehouse"];
}

- (void)showError
{
    [self showAlert:@"Loading Error"
            message:@"There was a problem loading the feed; please check your connection and try again."];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc = [[DetailViewController alloc] init];
    NSUInteger row = [indexPath row];
    Petition *petition = self.filteredPetitions[row];
    [dvc setPetition:petition];

    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredPetitions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    NSUInteger row = [indexPath row];
    Petition *petition = self.filteredPetitions[row];
    [[cell textLabel] setText:petition.title];
    [[cell detailTextLabel] setText:petition.body];

    return cell;
}
@end
