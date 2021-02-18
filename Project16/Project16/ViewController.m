//
//  ViewController.m
//  Project16
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import "Capital.h"
#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setDelegate:self];

    [self setTitle:@"Capitals"];

    Capital *london = [[Capital alloc] initWithTitle:@"London"
                                          coordinate:CLLocationCoordinate2DMake(51.07222, -0.1275)
                                                info:@"Home to the 2012 Summer Olympics."];

    Capital *oslo = [[Capital alloc] initWithTitle:@"Oslo"
                                        coordinate:CLLocationCoordinate2DMake(59.95, 10.75)
                                              info:@"Founded over a thousand years ago."];

    Capital *paris = [[Capital alloc] initWithTitle:@"Paris"
                                         coordinate:CLLocationCoordinate2DMake(48.8567, 2.3508)
                                               info:@"Often called the City of Light."];

    Capital *rome = [[Capital alloc] initWithTitle:@"Rome"
                                        coordinate:CLLocationCoordinate2DMake(41.9, 12.5)
                                              info:@"Has a whole country inside it."];

    Capital *washington = [[Capital alloc] initWithTitle:@"Washington"
                                              coordinate:CLLocationCoordinate2DMake(38.895111, -77.036667)
                                                    info:@"Named after George himself."];


    [self.mapView addAnnotations:@[(id)london, (id)oslo, (id)paris, (id)rome, (id)washington]];

    UIImage *image = [UIImage systemImageNamed:@"globe"];
    UIBarButtonItem *selectMap = [[UIBarButtonItem alloc] initWithImage:image
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(chooseMap)];

    [self.navigationItem setRightBarButtonItem:selectMap];
}

- (void)chooseMap
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Choose map type"
                                                                message:@"Pick one"
                                                         preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *standard = [UIAlertAction actionWithTitle:@"Standard"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView setMapType:MKMapTypeStandard];
    }];
    [ac addAction:standard];


    UIAlertAction *satellite = [UIAlertAction actionWithTitle:@"Satellite"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView setMapType:MKMapTypeSatellite];
    }];
    [ac addAction:satellite];

    UIAlertAction *hybrid = [UIAlertAction actionWithTitle:@"Hybrid"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView setMapType:MKMapTypeHybrid];
    }];
    [ac addAction:hybrid];


    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:NULL];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:NULL];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Capital class]]) {

        NSString *identifier = @"Capital";

        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

        if (annotationView) {
            [annotationView setAnnotation:annotation];
        } else {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
            [annotationView setCanShowCallout:YES];
            [annotationView setShowsLargeContentViewer:YES];
            [annotationView setPinTintColor:[UIColor blackColor]];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [annotationView setRightCalloutAccessoryView:button];
        }

        return annotationView;

    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (![view.annotation isKindOfClass:[Capital class]]) { return; }

    Capital *capital = (Capital *)view.annotation;

    NSString *placeName = capital.title;

    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:NULL
                                                                               bundle:NULL];
    webViewController.urlString = [@"https://en.wikipedia.org/wiki/" stringByAppendingString:placeName];
    webViewController.title = placeName;
    [self.navigationController pushViewController:webViewController animated:YES];

}

@end
