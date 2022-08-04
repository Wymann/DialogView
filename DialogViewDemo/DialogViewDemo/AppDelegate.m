//
//  AppDelegate.m
//  DialogViewDemo
//
//  Created by huaizhang.chen on 2022/8/4.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeViewController *viewController = [[HomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = nav;
    return YES;
}


@end
