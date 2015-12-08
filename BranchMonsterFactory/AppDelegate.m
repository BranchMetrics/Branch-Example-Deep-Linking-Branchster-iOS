//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"

#import "SplashViewController.h"

#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.initialMonster = nil;
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    
    //callback format: BranchUniversalObject *universalObject, BranchLinkProperties *linkProperties, NSError *error)
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *receivedMonster, BranchLinkProperties *linkProperties, NSError * error) {
        if (receivedMonster) {
            self.initialMonster = receivedMonster;
            NSLog(@"received monster: %@", [receivedMonster getMonsterName]);
        }
        
        //ok, to take care of the timing issues here (monster arrives before view loads / view loads before monster arrives:
        // --splashview will check for monster on when it loads, in case a monster has already arrived
        // --splashview will register for "monster_received" notifications, to handle late arriving monsters
        // --AppDelegate will notify splashviewcontroller when a new monster arrives
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"monster_received"
         object:nil];
        
    }];
    
    return YES;
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // To receive deep link parameters with the Branch link, you must also call handleDeepLink in the openURL AppDelegate call
    // This will call the deep link handler block you registered above
    [[Branch getInstance] handleDeepLink:url];
    
    //other possible code blocks that might want to do something, facebook, etc.
    //BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //if (!wasHandled)
    //twitter, etc.
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"resign");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"foreground");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"active");
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"terminate");
    
}

@end
