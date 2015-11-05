//
//  AppDelegate.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "AppDelegate.h"
#import "MBData.h"

#import <Fabric/Fabric.h>
#import "MoPub.h"

#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class], [MoPub class]]];
//    [[Crashlytics sharedInstance] setDebugMode:YES];
    [Crashlytics startWithAPIKey:@"a509b829dddd254ddfdb6efa1357935dbe17df00"];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [MBData initialize];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"applicationDidEnterBackground" object:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"applicationDidBecomeActive" object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"applicationWillTerminate" object:self];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"applicationDidReceiveLocalNotification" object:self];
}

@end