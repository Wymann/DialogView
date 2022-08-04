//
//  UIViewController+Dialog.m
//  TlifeApp
//
//  Created by Wymann Chan on 2021/12/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

#import "UIViewController+Dialog.h"


@implementation UIViewController (Dialog)

+ (UIViewController *)windowCurrentViewController {
    UIViewController *currentViewController = [self windowRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

+ (UIViewController *)windowRootViewController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}

@end
