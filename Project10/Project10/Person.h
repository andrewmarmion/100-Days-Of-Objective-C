//
//  Person.h
//  Project10
//
//  Created by Andrew Marmion on 03/02/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithName:(NSString *)name
                       image:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
