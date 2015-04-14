//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "AppDelegate.h"
//#import "Branch.h"
#import "MonsterPreferences.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initalize Branch and register the deep link handler
    // TODO : add initSessionWithLaunchOptions
    // if monster contained in Params, set VC to ViewerVC, else CreatorVC.
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // To receive deep link parameters with the Branch link, you must also call handleDeepLink in the openURL AppDelegate call
    // This will call the deep link handler block you registered above
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
