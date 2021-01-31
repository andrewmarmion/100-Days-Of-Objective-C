//
//  ViewController.m
//  Project1
//
//  Created by Andrew Marmion on 30/01/2021.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *pictures;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSError *error;
    NSArray *contents = [[NSArray alloc] init];
    contents = [fm contentsOfDirectoryAtPath:path error:&error];

    if (error) {
        NSLog(@"%@", error);
        return;
    }

    self.pictures = [[NSMutableArray alloc] init];

    for (id item in contents) {
        if ([item hasPrefix:@"nssl"]) {
            [self.pictures addObject:item];
        }
    }

    [self.pictures sortUsingSelector:@selector(compare:)];

    [self.tableView registerClass:UITableViewCell.self
           forCellReuseIdentifier:@"cell"];

    self.title = @"Storm Viewer";
    [[self.navigationController navigationBar] setPrefersLargeTitles:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.pictures count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];

    NSInteger row = [indexPath row];
    NSString *item = self.pictures[row];
    [[cell textLabel] setText:item];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:20]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Construct DetailViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];

    // Set image
    NSInteger row = [indexPath row];
    NSString *selectedImage = self.pictures[row];
    [vc setSelectedImage:selectedImage];

    // Set title
    NSInteger postion = row + 1;
    NSInteger count = [self.pictures count];
    NSString *titleString = [@"" stringByAppendingFormat:@"%ld / %ld", postion, count];
    [vc setTitleString:titleString];

    // show view controller
    [self.navigationController pushViewController:vc animated:YES];
}


@end
