//
//  AppDelegate.m
//  PChart
//
//  Created by JK.PENG on 13-10-12.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "AppDelegate.h"
#import "ChartViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    ChartViewController  *controller = [[ChartViewController alloc] init];
    UINavigationController  *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navController.navigationBar setTintColor:[UIColor orangeColor]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
