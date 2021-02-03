//
//  ViewController.m
//  Project10
//
//  Created by Andrew Marmion on 01/02/2021.
//

#import "ViewController.h"
#import "Person.h"
#import "PersonCell.h"

static NSString *identifier = @"Person";

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic) NSMutableArray<Person *> *people;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.people = [[NSMutableArray alloc] init];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPerson)];
    [self.navigationItem setLeftBarButtonItem:add];
}

- (void)addNewPerson
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setAllowsEditing:YES];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.people count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = (PersonCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    NSInteger item = [indexPath item];
    Person *person = self.people[item];

    NSURL *imagePath = [self getImagePathForName:person.image];
    NSString *path = [imagePath path];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [[cell imageView] setImage:image];
    [[[cell imageView] layer] setBorderColor:[UIColor colorWithWhite:0 alpha:0.3].CGColor];
    [[[cell imageView] layer] setBorderWidth:2];
    [[[cell imageView] layer] setCornerRadius:3];
    [[cell layer] setCornerRadius:7];

    [[cell label] setText:person.name];
    return cell;
}

- (void)renamePerson:(Person *)person {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Rename person"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleAlert];

    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Enter name here..."];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {

        UITextField *textField = [[ac textFields] firstObject];
        if (textField.text) {
            [person setName:textField.text];

            [self.collectionView reloadData];
        }
    }];

    [ac addAction:cancel];
    [ac addAction:ok];

    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = [indexPath item];
    Person *person = self.people[item];

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Choose..."
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];

    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self.people removeObjectAtIndex:item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self.collectionView reloadData];
    }];

    UIAlertAction *rename = [UIAlertAction actionWithTitle:@"Rename"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self renamePerson:person];
    }];

    [ac addAction:cancel];
    [ac addAction:rename];
    [ac addAction:delete];

    [ac setPreferredAction:rename];

    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image) {
        NSString *imageName = [[[NSUUID alloc] init] UUIDString];
        NSURL *imagePath = [self getImagePathForName:imageName];

        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [data writeToURL:imagePath atomically:YES];

        Person *person = [[Person alloc] initWithName:@"Unknown" image:imageName];
        [self.people addObject:person];
        [self.collectionView reloadData];

        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

- (NSURL *)getImagePathForName:(NSString *)name
{
    NSURL *imagePath = [[[self getDocumentsDirectory] URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"jpg"];
    return imagePath;
}

- (NSURL *)getDocumentsDirectory
{
   NSArray<NSURL *> *paths =[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                           inDomains:NSUserDomainMask];
    return paths[0];
}
@end
