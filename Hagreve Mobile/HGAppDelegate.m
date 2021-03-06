//
//  HGAppDelegate.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGAppDelegate.h"
#import <dispatch/dispatch.h>

#ifdef TESTFLIGHT
#import "TestFlight.h"
#endif

@implementation HGAppDelegate

@synthesize window = _window;

- (BOOL)saveStrikeDaysToCache:(HGStrikeDays*)strikeDays {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    if ([dirs count] != 1)
        return NO; // I won't save if I'm not sure of the path.

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [[dirs objectAtIndex:0]
                          stringByAppendingPathComponent:[mainBundle bundleIdentifier]];
    filePath = [filePath stringByAppendingPathComponent:kSaveStrikesPath];

    return [NSKeyedArchiver archiveRootObject:strikeDays toFile:filePath];
}

- (HGStrikeDays*)loadStrikesFromCache {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    if ([dirs count] != 1)
        return nil; // I won't save if I'm not sure of the path.

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [[dirs objectAtIndex:0]
                          stringByAppendingPathComponent:[mainBundle bundleIdentifier]];
    filePath = [filePath stringByAppendingPathComponent:kSaveStrikesPath];

    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef TESTFLIGHT
    [TestFlight takeOff:TESTFLIGHT_TOKEN];
#endif

    // Create the data controller and pass it to the root view controller.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    HGStrikeListTableViewController *rootViewController = (HGStrikeListTableViewController *)[navigationController topViewController];


    // Load the latest saved strike list (if possible);
    // Dispatch a thread to update the strike list.
    rootViewController.strikeDays = [self loadStrikesFromCache];
    [rootViewController scrollToTopAndRefresh];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    HGStrikeListTableViewController *rootViewController = (HGStrikeListTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
    [rootViewController reloadData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
