//
//  AppDelegate.m
//  BranchBots
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch. All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"
#import "RobotPreferences.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Branch getInstance:@"36930236817866882"] initUserSessionWithCallback:^(NSDictionary *params) {
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController *nextVC;
        if ([params objectForKey:@"monster"]) {
            [RobotPreferences setRobotName:[params objectForKey:@"monster_name"]];
            [RobotPreferences setFaceIndex:[[params objectForKey:@"face_index"] intValue]];
            [RobotPreferences setBodyIndex:[[params objectForKey:@"body_index"] intValue]];
            [RobotPreferences setColorIndex:[[params objectForKey:@"color_index"] intValue]];
            nextVC = [storyboard instantiateViewControllerWithIdentifier:@"BotViewerViewController"];
        } else {
            if (![RobotPreferences getRobotName])
                [RobotPreferences setRobotName:@""];
            nextVC = [storyboard instantiateViewControllerWithIdentifier:@"BotMakerViewController"];
        }
        [navController setViewControllers:@[nextVC] animated:YES];
    } withLaunchOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[Branch getInstance] handleDeepLink:url];
    return YES;
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
