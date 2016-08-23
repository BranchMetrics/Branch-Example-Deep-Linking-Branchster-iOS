//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "AppDelegate.h"

#import <mParticle-Apple-SDK/mParticle.h>
#import "mParticle.h"


@interface AppDelegate ()
@property BOOL  justLaunched;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.justLaunched = YES;
    
    [[MParticle sharedInstance] startWithKey:@"fe8104a87f1fdf4d928f69c7d5dcb9bd"
                                      secret:@"x2JpLm6QXAxCMpjxRpiDHyb4-biuW7Ddl6cdwIKct1YYvNtjeSLyJRnXFDcxyPUN"];
    
    if (self.justLaunched) {
        self.initialMonster = [self emptyMonster];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushEditView" object:nil];
        self.justLaunched = NO;
    }
    
    return YES;
}

- (NSMutableDictionary *)emptyMonster {
    NSMutableDictionary *empty = [[NSMutableDictionary alloc] init];
    
    [empty setValue:@"true" forKey:@"monster"];
    [empty setValue:@"0" forKey:@"face_index"];
    [empty setValue:@"0" forKey:@"body_index"];
    [empty setValue:@"0" forKey:@"color_index"];
    [empty setValue:@"" forKey:@"monster_name"];
    
    return empty;
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
