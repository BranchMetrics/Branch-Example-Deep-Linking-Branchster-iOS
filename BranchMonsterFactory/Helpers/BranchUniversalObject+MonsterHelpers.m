//
//  BranchUniversalObject+MonsterHelpers.m
//  BranchMonsterFactory
//
//  Created by Dan Walkowski on 12/4/15.
//  Copyright © 2015 Branch. All rights reserved.
//
#import "BranchUniversalObject.h"
#import "MonsterPartsFactory.h"

@implementation BranchUniversalObject (MonsterHelpers)

//must use this accessor
//(void)addMetadataKey:(NSString *)key value:(NSString *)value {



- (void)setMonsterName:(NSString *)name {
    [self addMetadataKey:@"monster_name" value:name];
}
- (NSString *)getMonsterName {
    return [self.metadata objectForKey:@"monster_name"];
}


- (void)setFaceIndex:(NSInteger)index {
    [self addMetadataKey:@"face_index" value:[@(index) stringValue]];
}

- (NSInteger)getFaceIndex {
    return [[self.metadata objectForKey:@"face_index"] integerValue];
}

- (void)setBodyIndex:(NSInteger)index {
    [self addMetadataKey:@"body_index" value:[@(index) stringValue]];
}

- (NSInteger)getBodyIndex {
    return [[self.metadata objectForKey:@"body_index"] integerValue];
}

- (void)setColorIndex:(NSInteger)index {
    [self addMetadataKey:@"color_index" value:[@(index) stringValue]];
}

- (NSInteger)getColorIndex {
    return [[self.metadata objectForKey:@"color_index"] intValue];
}

//special, computed, not stored

- (NSString *)getMonsterDescription {
    return [NSString stringWithFormat:[MonsterPartsFactory descriptionForIndex:[self getFaceIndex]], [self getMonsterName]];
}


@end
