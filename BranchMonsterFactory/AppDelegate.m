//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

@import Branch;
@import FBSDKCoreKit;
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
    
    // required by FB starting with v9.0
    [FBSDKApplicationDelegate.sharedInstance application:application didFinishLaunchingWithOptions:launchOptions];

    Branch *branch = [Branch getInstance];
    [branch checkPasteboardOnInstall];
    [branch setAppClipAppGroup:@"group.io.branch"];
    [branch registerFacebookDeepLinkingClass:[FBSDKAppLinkUtility class]];

    // Enable this to track Apple Search Ad attribution:
    [branch delayInitToCheckForSearchAds];

    /*
     * Initalize Branch and register the deep link handler:
     *
     * The deep link handler is called on every install/open to tell you if
     * the user had just clicked a deep link
     */

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
                if (BUO && BUO.contentMetadata.customMetadata[@"monster"]) {
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

                NSDictionary *appleSearchAd = [BNCPreferenceHelper sharedInstance].appleSearchAdDetails;
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

        // Optional: Set our own identitier for this user at Branch.
        // This could be an account number our other userID. It only needs to be set once.

        // User Identity
    //    NSString *userIdentity = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdentity"];
    //    if (!userIdentity) {
    //        userIdentity = [[NSUUID UUID] UUIDString];
    //        [[NSUserDefaults standardUserDefaults] setObject:userIdentity forKey:@"userIdentity"];
    //        [branch setIdentity:userIdentity];
    //    }
    
    return YES;
}

- (BranchUniversalObject *)emptyMonster {
    BranchUniversalObject *empty =
        [[BranchUniversalObject alloc] initWithTitle:@"Jingles Bingleheimer"];
    [empty setIsMonster];
    [empty setFaceIndex:0];
    [empty setBodyIndex:0];
    [empty setColorIndex:0];
    [empty setMonsterName:@""];
    return empty;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[Branch getInstance] application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *))restorationHandler {
    [[Branch getInstance] continueUserActivity:userActivity];
    return YES;
}

@end
