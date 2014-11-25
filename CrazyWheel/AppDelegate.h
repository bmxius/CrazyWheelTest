//
//  AppDelegate.h
//  CrazyWheel
//
//  Created by Stig on 25.11.14.
//  Copyright (c) 2014 YESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic) BOOL isConnectionExists;
@property (nonatomic) BOOL isWiFi;
- (BOOL)hasInternet;

@end

