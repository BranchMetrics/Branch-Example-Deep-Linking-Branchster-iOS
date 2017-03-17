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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Localytics;
@import Tune;

@interface AppDelegate ()
@property (nonatomic) BOOL justLaunched;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //  We can add Tune integration too:
//  [Tune setDebugMode:YES];    //  eDebug
    [Tune initializeWithTuneAdvertiserId:@"192600"
                       tuneConversionKey:@"06232296d8d6cb4faefa879d1939a37a"];

    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link

    self.justLaunched = YES;
    Branch *branch = [Branch getInstance];
    [branch delayInitToCheckForSearchAds];
//  [branch setAppleSearchAdsDebugMode];    //  Turn this on to debug Apple Search Ads
    [branch registerFacebookDeepLinkingClass:[FBSDKAppLinkUtility class]];
    [branch initSessionWithLaunchOptions:launchOptions
        andRegisterDeepLinkHandlerUsingBranchUniversalObject:
            ^ (BranchUniversalObject *BUO, BranchLinkProperties *linkProperties, NSError *error) {
                if (BUO && [BUO.metadata objectForKey:@"monster"]) {
                    self.initialMonster = BUO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditAndViewerViews" object:nil];
                }
                else if (self.justLaunched) {
                    self.initialMonster = [self emptyMonster];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
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

//  [Localytics setLoggingEnabled:YES]; //  Turn this on to debug Localytics
    [Localytics autoIntegrate:@"0d738869f6b0f04eb1341f5-fbdada7a-f4ff-11e4-3279-00f82776ce8b"
        launchOptions:launchOptions];

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
    [Tune measureSession];
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
