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
@property BOOL firstTime;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.firstTime = YES;

    self.initialMonster = nil;
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    [branch setDebug];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *receivedMonster, BranchLinkProperties *linkProperties, NSError * error) {
        
        NSLog(@"\n\nJust retrieved data from server: %@\n\n", receivedMonster);
        
        if (receivedMonster) {
            //one was delivered
            self.initialMonster = receivedMonster;
        } else if(self.firstTime) {
            //make a new one
            self.initialMonster = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:[NSString stringWithFormat:@"MONSTER_%u", arc4random_uniform(10000)]];
            [self.initialMonster setFaceIndex:0];
            [self.initialMonster setBodyIndex:0];
            [self.initialMonster setColorIndex:0];
            [self.initialMonster setMonsterName:@"Bingles Jingleheimer"];
            self.firstTime = NO;
        }
        
        if(self.initialMonster) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"monster_received" object:nil];
        }

    }];
    
    return YES;
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // To receive deep link parameters with the Branch link, you must also call handleDeepLink in the openURL AppDelegate call
    // This will call the deep link handler block registered above
    [[Branch getInstance] handleDeepLink:url];
    
    //other possible code blocks that might want to do something, facebook, etc.
    //BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //if (!wasHandled)
    //twitter, etc.
    
    return YES;
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
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
