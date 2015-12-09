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

//create a new, random monster if there isn't one at launch


@property BOOL launched;
@property BOOL foregrounded;

@property BOOL gotMonster;

@property NSArray* firstNames;
@property NSArray* lastNames;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.launched = YES;
    self.foregrounded = NO;
    
    self.firstNames = @[@"Francine", @"Darren", @"Blanche", @"Wendell", @"Fresia", @"Bart"];
    self.lastNames = @[@"Adirondack", @"Peabody", @"Newsome", @"Wallaby", @"French", @"Brentwood"];
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    [branch setDebug];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *receivedMonster, BranchLinkProperties *linkProperties, NSError * error) {
        
        NSLog(@"\n\nJust retrieved data from server: %@\n\n", receivedMonster);
        
        if (self.launched) {
            
            if (receivedMonster) {
                self.initialMonster = receivedMonster;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
            } else if(self.launched) {
                self.initialMonster = [self createRandomMonster];
                self.launched = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
            }
        } else if(self.foregrounded) {
            
            if (receivedMonster) {
                self.initialMonster = receivedMonster;
                self.foregrounded = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
            }
        }

    }];
    
    return YES;
}

- (BranchUniversalObject *) createRandomMonster {
    BranchUniversalObject*  random = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:[NSString stringWithFormat:@"MONSTER_%u", arc4random_uniform(10000000)]];
    [random setFaceIndex:arc4random_uniform(5)];
    [random setBodyIndex:arc4random_uniform(5)];
    [random setColorIndex:arc4random_uniform(8)];
    [random setMonsterName:[NSString stringWithFormat:@"%@ %@", self.firstNames[arc4random_uniform(6)], self.lastNames[arc4random_uniform(6)] ]];
    return random;
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
