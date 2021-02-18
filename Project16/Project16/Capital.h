//
//  Capital.h
//  Project16
//
//  Created by Andrew Marmion on 18/02/2021.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Capital : NSObject

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *info;

-(id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate info:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
