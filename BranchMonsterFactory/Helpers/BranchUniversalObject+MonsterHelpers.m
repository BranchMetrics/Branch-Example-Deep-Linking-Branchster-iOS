//
//  BranchUniversalObject+MonsterHelpers.m
//  BranchMonsterFactory
//
//  Created by Dan Walkowski on 12/4/15.
//  Copyright © 2015 Branch. All rights reserved.
//

#import "BranchUniversalObject+MonsterHelpers.h"
#import "MonsterPartsFactory.h"

@implementation BranchUniversalObject (MonsterHelpers)

//must use this accessor
//(void)addMetadataKey:(NSString *)key value:(NSString *)value {



- (void)setIsMonster{
    self.contentMetadata.customMetadata[@"monster"] = @"true";
}

- (void)setMonsterName:(NSString *)name {
    self.contentMetadata.customMetadata[@"monster_name"] = name;
}
- (NSString *)getMonsterName {
    return self.contentMetadata.customMetadata[@"monster_name"];
}


- (void)setFaceIndex:(NSInteger)index {
    self.contentMetadata.customMetadata[@"face_index"] = [@(index) stringValue];
}

- (NSInteger)getFaceIndex {
    return [self.contentMetadata.customMetadata[@"face_index"] integerValue];
}

- (void)setBodyIndex:(NSInteger)index {
    self.contentMetadata.customMetadata[@"body_index"] = [@(index) stringValue];
}

- (NSInteger)getBodyIndex {
    return [self.contentMetadata.customMetadata[@"body_index"] integerValue];
}

- (void)setColorIndex:(NSInteger)index {
    self.contentMetadata.customMetadata[@"color_index"] = [@(index) stringValue];
}

- (NSInteger)getColorIndex {
    return [self.contentMetadata.customMetadata[@"color_index"] intValue];
}

//special, computed, not stored

- (NSString *)getMonsterDescription {
    return [NSString stringWithFormat:[MonsterPartsFactory descriptionForIndex:[self getFaceIndex]], [self getMonsterName]];
}


@end
