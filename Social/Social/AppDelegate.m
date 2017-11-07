//
//  AppDelegate.m
//  Social
//
//  Created by feng jiang on 9/20/17.
//  Copyright © 2017 feng jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TabBarController *tabBarController = [TabBarController new];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LocationManager sharedManager] stopLoadUserLocation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self updateLocation];
}

- (void)updateLocation {
    if ([LocationManager isLocationServicesEnabled]) {
        [[LocationManager sharedManager] startLoadUserLocation];
    }
}




@end
