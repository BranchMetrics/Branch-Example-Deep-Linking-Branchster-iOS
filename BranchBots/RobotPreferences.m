//
//  RobotPreferences.m
//  BranchBots
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch. All rights reserved.
//

#import "RobotPreferences.h"
#import "RobotPartsFactory.h"

@implementation RobotPreferences

+ (void)setRobotName:(NSString *)name {
    [RobotPreferences writeObjectToDefaults:@"monster_name" value:name];
}
+ (NSString *)getRobotName {
    return (NSString *)[RobotPreferences readObjectFromDefaults:@"monster_name"];
}

+ (NSString *)getRobotDescription {
    NSString *description = [RobotPartsFactory descriptionForIndex:[self getFaceIndex]];
    return [NSString stringWithFormat:description, [RobotPreferences getRobotName]];
}

+ (void)setFaceIndex:(NSInteger)index {
    [RobotPreferences writeIntegerToDefaults:@"face_index" value:index];
}

+ (NSInteger)getFaceIndex {
    return [RobotPreferences readIntegerFromDefaults:@"face_index"];
}

+ (void)setBodyIndex:(NSInteger)index {
    [RobotPreferences writeIntegerToDefaults:@"body_index" value:index];
}

+ (NSInteger)getBodyIndex {
    return [RobotPreferences readIntegerFromDefaults:@"body_index"];
}

+ (void)setColorIndex:(NSInteger)index {
    [RobotPreferences writeIntegerToDefaults:@"color_index" value:index];
}

+ (NSInteger)getColorIndex {
    return [RobotPreferences readIntegerFromDefaults:@"color_index"];
}


+(void) writeIntegerToDefaults: (NSString *) key value: (NSInteger) value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}
+(void) writeBoolToDefaults: (NSString *) key value: (BOOL) value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
+(void) writeObjectToDefaults: (NSString *) key value: (NSObject *) value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(NSObject *) readObjectFromDefaults: (NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
+(BOOL) readBoolFromDefaults: (NSString *) key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}
+(NSInteger) readIntegerFromDefaults: (NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

@end
