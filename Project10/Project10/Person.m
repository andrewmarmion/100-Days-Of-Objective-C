//
//  Person.m
//  Project10
//
//  Created by Andrew Marmion on 03/02/2021.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name image:(NSString *)image
{
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
    }

    return self;
}
@end
