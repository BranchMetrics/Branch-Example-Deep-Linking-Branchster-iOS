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

//create a new, random monster if there isn't one at launch


@property BOOL  justLaunched;
@property BOOL foregrounded;

@property BOOL gotMonster;

@property NSArray* firstNames;
@property NSArray* lastNames;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.justLaunched = YES;
    self.foregrounded = NO;
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    
    //[branch setDebug];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *BUO, BranchLinkProperties *linkProperties, NSError * error) {
        
        if (BUO && [BUO.metadata objectForKey:@"monster"]) {
            
            BranchUniversalObject* receivedMonster = BUO;
            
            NSLog(@"\n\nJust retrieved data from server: %@\n\n", receivedMonster);
            
            if (self.justLaunched) {
                
                self.justLaunched = NO; //turn off
                
                if (receivedMonster) {
                    self.initialMonster = receivedMonster;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
                } else {
                    self.initialMonster = [self emptyMonster];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
                }
            } else if(self.foregrounded) {
                if (receivedMonster) {
                    self.initialMonster = receivedMonster;
                    self.foregrounded = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
                }
            }
            
        } else {
            self.initialMonster = [self emptyMonster];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
        }
    
    }];
    
    return YES;
}

- (BranchUniversalObject *) emptyMonster {
    
    
    BranchUniversalObject*  empty = [[BranchUniversalObject alloc] initWithTitle:@""];
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
    NSLog(@"resign");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"foreground");
    self.foregrounded = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"active");
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"terminate");
    
}

@end
