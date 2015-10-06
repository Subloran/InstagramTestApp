//
//  AppDelegate.m
//  InstagramTestApp
//
//  Created by Artem on 05/10/15.
//  Copyright (c) 2015 Artem. All rights reserved.
//

#import "AppDelegate.h"
#import "PopularPostsViewController.h"
#import "LoginViewController.h"
#import "InstagramAPI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController* rootController;
    if ([InstagramAPI sharedInstance].tokenString.length > 0)
    {
        PopularPostsViewController* popularPosts = [[PopularPostsViewController alloc] initWithNibName:@"PopularPostsViewController" bundle:nil];
        rootController = popularPosts;
    }
    else
    {
        LoginViewController* loginController = [[LoginViewController alloc] init];
        rootController = loginController;
    }
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
