//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate ()


@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initalize Branch and register the deep link handler
    // The deep link handler is called on every install/open to tell you if the user had just clicked a deep link
    Branch *branch = [Branch getInstance];
    
    //callback format: BranchUniversalObject *universalObject, BranchLinkProperties *linkProperties, NSError *error)
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandlerUsingBranchUniversalObject:^(BranchUniversalObject *receivedMonster, BranchLinkProperties *linkProperties, NSError * error) {
        
//        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController *nextVC;
//        
        
        //FIX FIX: we are receiving a BUO from the network, dumping all it's parts out, then putting them all in
        //  nsuserdefaults, then getting them all out again, reassembling them back into a BUO, and sending it out when we share it.
        //  we should really just be passing the BUO around from controller to controller in segues, and only be saving out the
        //  current monster when we get sent to the background.

        //the three options, in order are:
        // 1. we get a BUO (containing a branchster) from someone sharing it to us OR ELSE
        // 2. we find a previous one stored to disk OR ELSE
        // 3. we make a new one
        
        
        if (receivedMonster) {
            self.initialMonsterOrNULL = receivedMonster;
        } else self.initialMonsterOrNULL = NULL;
        
//            [MonsterPreferences setMonsterName:[receivedMonster.metadata objectForKey:@"monster_name"]];
//            [MonsterPreferences setFaceIndex:[[receivedMonster.metadata objectForKey:@"face_index"] intValue]];
//            [MonsterPreferences setBodyIndex:[[receivedMonster.metadata objectForKey:@"body_index"] intValue]];
//            [MonsterPreferences setColorIndex:[[receivedMonster.metadata objectForKey:@"color_index"] intValue]];
//            
//            // Choose the monster viewer as the next view controller
//            nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
            
            
//        // Otherwise, the app is being opened up from the home screen or from the app store
//        // Load the next logical view controller
//        } else {
//            
//            // If a name has been saved in preferences, then this user has already created a monster
//            // Load the viewer
//            if (![MonsterPreferences getMonsterName]) {
//                [MonsterPreferences setMonsterName:@""];
//                
//                // Choose the monster viewer as the next view controller
//                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterCreatorViewController"];
//                
//            // If no name has been saved, this user is new, so load the monster maker screen
//            } else {
//                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
//            }
//        }
//        
//        // launch the next view controller
//        [navController setViewControllers:@[nextVC] animated:YES];
    }];
    
    return YES;
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // To receive deep link parameters with the Branch link, you must also call handleDeepLink in the openURL AppDelegate call
    // This will call the deep link handler block you registered above
    if (!wasHandled)
        [[Branch getInstance] handleDeepLink:url];
    
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
