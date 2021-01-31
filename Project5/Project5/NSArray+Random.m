//
//  NSArray+Random.m
//  Project5
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

- (id)randomObject
{
    // Force casting this to an int to remmove the compiler warning when using arc4Random_uniform
    // [self count] return an NSUInteger which is 64bit
    // arc4random_uniform uses an int which is 32bit,
    // so there is a possible loss of precision by performing this cast
    // We should be safe casting as we are not using more than 2^32-1 elements in the array.
    int mycount = (int)[self count];
    if (mycount) {
        return [self objectAtIndex:arc4random_uniform(mycount)];
    } else {
        return nil;
    }
}

@end
