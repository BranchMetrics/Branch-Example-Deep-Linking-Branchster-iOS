//
//  MonsterPartsFactory.h
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

@import UIKit;

@interface MonsterPartsFactory : NSObject

+ (UIColor *)colorForIndex:(NSInteger)index;
+ (UIImage *)imageForBody:(NSInteger)index;
+ (UIImage *)imageForFace:(NSInteger)index;
+ (NSString *)descriptionForIndex:(NSInteger)index;
+ (NSInteger)sizeOfBodyArray;
+ (NSInteger)sizeOfFaceArray;

@end
