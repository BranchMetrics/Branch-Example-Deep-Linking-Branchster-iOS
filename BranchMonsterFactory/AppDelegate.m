//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

@import Branch;
//@import FBSDKCoreKit;
//@import Localytics;
//@import Tune;
#import "AppDelegate.h"
#import "SplashViewController.h"
#import "BranchUniversalObject+MonsterHelpers.h"

@interface AppDelegate ()
@property (nonatomic) BOOL justLaunched;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BNCLogSetDisplayLevel(BNCLogLevelAll);
    self.justLaunched = YES;

    // We can add Tune integration too:
    // [Tune setDebugMode:YES];
    // [Tune initializeWithTuneAdvertiserId:@"192600"
    //                    tuneConversionKey:@"06232296d8d6cb4faefa879d1939a37a"];
    // [Tune setDebugMode:YES];

    Branch *branch = [Branch getInstance];
    // [branch registerFacebookDeepLinkingClass:[FBSDKAppLinkUtility class]];

    /*
     * Un-comment this to track Apple Search Ad attribution:
     * [branch delayInitToCheckForSearchAds];
     */
    [branch delayInitToCheckForSearchAds];

    /*
     * Initalize Branch and register the deep link handler:
     *
     * The deep link handler is called on every install/open to tell you if
     * the user had just clicked a deep link
     */

    // Optional: Set our own identitier for this user at Branch.
    // This could be an account number our other userID. It only needs to be set once.

    NSString *userIdentity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdentity"];
    if (!userIdentity) {
        userIdentity = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:userIdentity forKey:@"userIdentity"];
        [branch setIdentity:userIdentity];
    }

    [branch initSessionWithLaunchOptions:launchOptions
        andRegisterDeepLinkHandlerUsingBranchUniversalObject:
            ^ (BranchUniversalObject *BUO, BranchLinkProperties *linkProperties, NSError *error) {

                if (linkProperties.controlParams[@"$3p"] &&
                    linkProperties.controlParams[@"$web_only"]) {
                    NSURL *url = [NSURL URLWithString:linkProperties.controlParams[@"$original_url"]];
                    if (url) {
                        [[NSNotificationCenter defaultCenter]
                           postNotificationName:@"pushWebView"
                           object:self
                           userInfo:@{@"URL": url}];
                   }
                } else
                if (BUO && [BUO.metadata objectForKey:@"monster"]) {
                    self.initialMonster = BUO;
                    [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"pushEditAndViewerViews"
                        object:nil];
                } else
                if (self.justLaunched) {
                    self.initialMonster = [self emptyMonster];
                    [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"pushEditView"
                        object:nil];
                    self.justLaunched = NO;
                }

                NSDictionary *appleSearchAd = [BNCPreferenceHelper preferenceHelper].appleSearchAdDetails;
                NSString *campaign = appleSearchAd[@"Version3.1"][@"iad-campaign-name"];
                if (campaign.length) {
                    NSLog(@"Got an Apple Search Ad Result :\n%@", appleSearchAd);
                    /*
                    NSString *message = [NSString stringWithFormat:@"Campaign: %@", campaign];
                    UIAlertView *alertView =
                        [[UIAlertView alloc]
                            initWithTitle:@"Apple Search Ad Result!"
                            message:message
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
                    [alertView show];
                    */
                }
            }];

    // [Localytics setLoggingEnabled:YES]; //  Turn this on to debug Localytics
    // [Localytics autoIntegrate:@"0d738869f6b0f04eb1341f5-fbdada7a-f4ff-11e4-3279-00f82776ce8b"
    //     launchOptions:launchOptions];

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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Attribution will not function without the measureSession call included
    // [Tune measureSession];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[Branch getInstance] handleDeepLink:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void (^)(NSArray *))restorationHandler {
    [[Branch getInstance] continueUserActivity:userActivity];
    return YES;
}

@end
