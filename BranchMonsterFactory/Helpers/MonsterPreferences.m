//
//  MonsterPreferences.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "MonsterPreferences.h"
#import "MonsterPartsFactory.h"

@implementation MonsterPreferences

+ (void)setMonsterName:(NSString *)name {
    [MonsterPreferences writeObjectToDefaults:@"monster_name" value:name];
}
+ (NSString *)getMonsterName {
    return (NSString *)[MonsterPreferences readObjectFromDefaults:@"monster_name"];
}

+ (NSString *)getMonsterDescription {
    return [NSString stringWithFormat:[MonsterPartsFactory descriptionForIndex:[self getFaceIndex]], [self getMonsterName]];
}

+ (void)setFaceIndex:(NSInteger)index {
    [MonsterPreferences writeIntegerToDefaults:@"face_index" value:index];
}

+ (NSInteger)getFaceIndex {
    return [MonsterPreferences readIntegerFromDefaults:@"face_index"];
}

+ (void)setBodyIndex:(NSInteger)index {
    [MonsterPreferences writeIntegerToDefaults:@"body_index" value:index];
}

+ (NSInteger)getBodyIndex {
    return [MonsterPreferences readIntegerFromDefaults:@"body_index"];
}

+ (void)setColorIndex:(NSInteger)index {
    [MonsterPreferences writeIntegerToDefaults:@"color_index" value:index];
}

+ (NSInteger)getColorIndex {
    return [MonsterPreferences readIntegerFromDefaults:@"color_index"];
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
