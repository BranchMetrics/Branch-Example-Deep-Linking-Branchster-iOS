//
//  RobotPreferences.h
//  BranchBots
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobotPreferences : NSObject

+ (void)setRobotName:(NSString *)name;
+ (NSString *)getRobotName;

+ (NSString *)getRobotDescription;

+ (void)setFaceIndex:(NSInteger)index;
+ (NSInteger)getFaceIndex;

+ (void)setBodyIndex:(NSInteger)index;
+ (NSInteger)getBodyIndex;

+ (void)setColorIndex:(NSInteger)index;
+ (NSInteger)getColorIndex;

@end
