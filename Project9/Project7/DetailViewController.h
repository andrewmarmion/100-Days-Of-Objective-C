//
//  DetailViewController.h
//  Project7
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class Petition;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Petition *petition;

@end

NS_ASSUME_NONNULL_END
