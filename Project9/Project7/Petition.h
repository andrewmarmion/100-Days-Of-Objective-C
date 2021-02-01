//
//  Petition.h
//  Project7
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Petition : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSNumber *signatureCount;

@end

NS_ASSUME_NONNULL_END
