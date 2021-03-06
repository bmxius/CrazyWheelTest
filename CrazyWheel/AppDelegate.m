//
//  AppDelegate.m
//  CrazyWheel
//
//  Created by Stig on 25.11.14.
//  Copyright (c) 2014 YESS. All rights reserved.
//

#import "AppDelegate.h"
#import "JDStatusBarNotification.h"

static NSString *const kServer = @"http://crazy-dev.wheely.com";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self startReachability];
    
    return YES;
}

- (void)startReachability{
    
    self.hostReachability = [Reachability reachabilityWithHostName:kServer];
    [self.hostReachability startNotifier];
    NSNotification *not = [NSNotification notificationWithName:kReachabilityChangedNotification object:self.hostReachability];
    [self reachabilityChanged:not];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
            [JDStatusBarNotification showWithStatus:@"Возможно, нет интернета" dismissAfter:1.0];
            self.isConnectionExists = NO;
            self.isWiFi = NO;
            break;
            
        case ReachableViaWiFi:
            self.isConnectionExists = YES;
            self.isWiFi = YES;
            
            break;
            
        case ReachableViaWWAN:
            self.isConnectionExists = YES;
            self.isWiFi = NO;
            
            break;
    }
}

- (BOOL)hasInternet{
    
    if (self.isConnectionExists) {
        return YES;
    } else {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
