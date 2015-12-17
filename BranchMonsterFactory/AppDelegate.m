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
#import "BranchUniversalObject+MonsterHelpers.h"
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate ()
@property BOOL  justLaunched;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.justLaunched = YES;
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    
    //[branch setDebug];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *BUO, BranchLinkProperties *linkProperties, NSError *error) {
        
        if (BUO && [BUO.metadata objectForKey:@"monster"]) {
            
            BranchUniversalObject *receivedMonster = BUO;
            
            NSLog(@"\n\nJust retrieved data from server: %@\n\n", receivedMonster);
            
            
            if (receivedMonster) {
                //always show a new monster, if we received one
                self.initialMonster = receivedMonster;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
            }
            
        } else {
            //didn't get a monster
            if (self.justLaunched) {
                self.initialMonster = [self emptyMonster];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
                self.justLaunched = NO;
            }
        }
    }];
    
    return YES;
}


- (BranchUniversalObject *) emptyMonster {
    BranchUniversalObject*  empty = [[BranchUniversalObject alloc] initWithTitle:@"Jingles Bingleheimer"];
    [empty setIsMonster];
    [empty setFaceIndex:0];
    [empty setBodyIndex:0];
    [empty setColorIndex:0];
    [empty setMonsterName:@""];
    return empty;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // To receive deep link parameters with the Branch link, you must also call handleDeepLink in the openURL AppDelegate call
    // This will call the deep link handler block registered above
    [[Branch getInstance] handleDeepLink:url];
    
    //other possible code blocks that might want to do something, facebook, etc.
    //BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //if (!wasHandled)...
    
    return YES;
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
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
