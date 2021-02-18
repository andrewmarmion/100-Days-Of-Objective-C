//
//  Capital.m
//  Project16
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import "Capital.h"

@interface Capital () <MKAnnotation>

@end

@implementation Capital


-(id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate info:(NSString *)info
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
        self.info = info;
    }
    return self;
}


@end
