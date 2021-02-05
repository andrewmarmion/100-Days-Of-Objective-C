//
//  Person.m
//  Project10
//
//  Created by Andrew Marmion on 03/02/2021.
//

#import "Person.h"

@interface Person () <NSSecureCoding>

@end

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
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_image forKey:@"image"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];

    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _image = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
