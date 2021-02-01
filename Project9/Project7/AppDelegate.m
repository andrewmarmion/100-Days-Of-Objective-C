//
//  AppDelegate.m
//  Project7
//
//  Created by Andrew Marmion on 31/01/2021.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    if (tabBarController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NavController"];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated
                                                                   tag:1];
        tabBarController.viewControllers = [[tabBarController viewControllers] arrayByAddingObject:vc];
    }

    return YES;
}

@end
