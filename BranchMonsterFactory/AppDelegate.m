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
@import Localytics;

@interface AppDelegate ()
@property (nonatomic) BOOL justLaunched;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.justLaunched = YES;
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *BUO, BranchLinkProperties *linkProperties, NSError *error) {
        NSDictionary *params = [[Branch getInstance] getLatestReferringParams];
        if (params[@"+non_branch_link"] && [params[@"+non_branch_link"] rangeOfString:@"open_web_browser=true"].location != NSNotFound) {
            NSURL *url = [NSURL URLWithString:params[@"+non_branch_link"]];
            if (url) {
                [application openURL:url];
                // check to make sure your existing deep linking logic, if any, is not executed
                return;
            }
        }
        
        if (BUO && [BUO.metadata objectForKey:@"monster"]) {
            self.initialMonster = BUO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
        }
        else if (self.justLaunched) {
            self.initialMonster = [self emptyMonster];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
            self.justLaunched = NO;
        }
    }];

//    [Localytics setLoggingEnabled:YES];
    [Localytics autoIntegrate:@"0d738869f6b0f04eb1341f5-fbdada7a-f4ff-11e4-3279-00f82776ce8b" launchOptions:launchOptions];

    return YES;
}

- (BranchUniversalObject *)emptyMonster {
    BranchUniversalObject *empty = [[BranchUniversalObject alloc] initWithTitle:@"Jingles Bingleheimer"];
    [empty setIsMonster];
    [empty setFaceIndex:0];
    [empty setBodyIndex:0];
    [empty setColorIndex:0];
    [empty setMonsterName:@""];
    return empty;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[Branch getInstance] handleDeepLink:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    [[Branch getInstance] continueUserActivity:userActivity];
    return YES;
}

@end
