//
//  ViewController.m
//  Project13
//
//  Created by Andrew Marmion on 06/02/2021.
//


#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UISlider *intensity;
@property (weak, nonatomic) IBOutlet UIButton *changeFilterButton;

@property (nonatomic) UIImage *currentImage;

@property (nonatomic) CIContext *context;
@property (nonatomic) CIFilter *currentFilter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(importPicture)];
    [self.navigationItem setRightBarButtonItem:add];
    [self setTitle:@"YACIFP"];


    self.context = [[CIContext alloc] init];
    self.currentFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [self.changeFilterButton setTitle:@"CISepiaTone" forState:UIControlStateNormal];
}

- (void)importPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setAllowsEditing:YES];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)changeFilter:(UIButton *)sender
{

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Choose filter"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *bumpDistortion = [UIAlertAction actionWithTitle:@"CIBumpDistortion"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:bumpDistortion];

    UIAlertAction *gaussianBlur = [UIAlertAction actionWithTitle:@"CIGaussianBlur"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:gaussianBlur];

    UIAlertAction *pixellate = [UIAlertAction actionWithTitle:@"CIPixellate"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:pixellate];

    UIAlertAction *sepiaTone = [UIAlertAction actionWithTitle:@"CISepiaTone"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:sepiaTone];

    UIAlertAction *twirlDistortion = [UIAlertAction actionWithTitle:@"CITwirlDistortion"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:twirlDistortion];

    UIAlertAction *unsharpMask = [UIAlertAction actionWithTitle:@"CIUnsharpMask"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:unsharpMask];

    UIAlertAction *vignette = [UIAlertAction actionWithTitle:@"CIVignette"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self setFilterForAction:action];
    }];

    [ac addAction:vignette];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];

    [ac addAction:cancel];

    UIPopoverPresentationController *popc = [ac popoverPresentationController];
    if (popc) {
        [popc setSourceView:sender];
        [popc setSourceRect:sender.bounds];
    }

    [self presentViewController:ac animated:YES completion:nil];

}

- (void)setFilterForAction:(UIAlertAction *)action
{
    if (action.title) {
        [self.changeFilterButton setTitle:action.title forState:UIControlStateNormal];
        if (self.currentImage) {
            NSString *title = [action title];
            self.currentFilter = [CIFilter filterWithName:title];

            CIImage *beginImage = [CIImage imageWithCGImage:self.currentImage.CGImage];
            [self.currentFilter setValue:beginImage forKey:kCIInputImageKey];
            [self applyProcessing];
        }
    }
}

- (IBAction)save:(id)sender
{
    if (self.imageview.image) {
        UIImageWriteToSavedPhotosAlbum(self.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        [self showAlertWithTitle:@"No image!" message:@"Select an image first!"];
    }

}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {


    NSString *title;
    NSString *message;

    if (error.localizedDescription == NULL) {
        title = @"Saved!";
        message = @"Your altered image has been saved to your photos.";
    } else {
        title= @"Save error!";
        message = error.localizedDescription;
    }

    [self showAlertWithTitle:title message:message];

}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)intensityChanged:(id)sender
{
    [self applyProcessing];
}

- (void)applyProcessing
{

        NSArray *inputKeys = [self.currentFilter inputKeys];

        if ([inputKeys containsObject:kCIInputIntensityKey]) {
            NSNumber *value = [NSNumber numberWithFloat:self.intensity.value];
            [self.currentFilter setValue:value forKey:kCIInputIntensityKey];
        }

        if ([inputKeys containsObject:kCIInputRadiusKey]) {
            float radius = self.intensity.value * 200.0;
            NSNumber *value = [NSNumber numberWithFloat:radius];
            [self.currentFilter setValue:value forKey:kCIInputRadiusKey];
        }

        if ([inputKeys containsObject:kCIInputScaleKey]) {
            float scale = self.intensity.value * 10.0;
            NSNumber *value = [NSNumber numberWithFloat:scale];
            [self.currentFilter setValue:value forKey:kCIInputScaleKey];
        }

        if ([inputKeys containsObject:kCIInputCenterKey]) {
            CGFloat x = self.currentImage.size.width / 2.0;
            CGFloat y = self.currentImage.size.height / 2.0;
            CIVector *vector = [CIVector vectorWithX:x Y:y];
            [self.currentFilter setValue:vector forKey:kCIInputCenterKey];
        }


        if (self.currentFilter.outputImage) {
            CGImageRef cgImageRef = [self.context createCGImage:self.currentFilter.outputImage
                                                       fromRect:self.currentFilter.outputImage.extent];
            UIImage *processedImage = [UIImage imageWithCGImage:cgImageRef];
            [self.imageview setImage:processedImage];

            // Make sure we release the image after using it
            CGImageRelease(cgImageRef);
        }


}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = (UIImage *)info[UIImagePickerControllerEditedImage];

    if (image) {
        self.currentImage = image;

        CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
        [self.currentFilter setValue:beginImage forKey:kCIInputImageKey];
        [self applyProcessing];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
