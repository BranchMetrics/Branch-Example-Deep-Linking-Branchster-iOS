//
//  BranchUniversalObject+MonsterHelpers.h
//  BranchMonsterFactory
//
//  Created by Dan Walkowski on 12/4/15.
//  Copyright © 2015 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BranchUniversalObject.h"

@interface BranchUniversalObject (MonsterHelpers)

//need to have this to be recognized as a monster  (just a BOOL)
- (void) setIsMonster;

- (void)setMonsterName:(NSString *)name;

- (NSString *)getMonsterName;

- (void)setFaceIndex:(NSInteger)index;

- (NSInteger)getFaceIndex;

- (void)setBodyIndex:(NSInteger)index;

- (NSInteger)getBodyIndex;

- (void)setColorIndex:(NSInteger)index;

- (NSInteger)getColorIndex;

//special, computed not stored
- (NSString *)getMonsterDescription;

@end
