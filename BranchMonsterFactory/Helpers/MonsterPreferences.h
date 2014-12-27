//
//  MonsterPreferences.h
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface MonsterPreferences : NSObject

+ (void)setMonsterName:(NSString *)name;
+ (NSString *)getMonsterName;

+ (NSString *)getMonsterDescription;

+ (void)setFaceIndex:(NSInteger)index;
+ (NSInteger)getFaceIndex;

+ (void)setBodyIndex:(NSInteger)index;
+ (NSInteger)getBodyIndex;

+ (void)setColorIndex:(NSInteger)index;
+ (NSInteger)getColorIndex;

@end
