//
//  MonsterPartsFactory.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "MonsterPartsFactory.h"

@implementation MonsterPartsFactory

static NSArray *colorArray;
static NSArray *bodyArray;
static NSArray *faceArray;
static NSArray *descriptionArray;

+ (NSArray *)colorArray {
    if (!colorArray)
        colorArray = @[
                       [UIColor colorWithRed:0.141 green:0.643 blue:0.8666 alpha:1],
                       [UIColor colorWithRed:0.925 green:0.384 blue:0.4745 alpha:1],
                       [UIColor colorWithRed:0.161 green:0.706 blue:0.443 alpha:1],
                       [UIColor colorWithRed:0.965 green:0.6 blue:0.220 alpha:1],
                       [UIColor colorWithRed:0.518 green:0.149 blue:0.545 alpha:1],
                       [UIColor colorWithRed:0.141 green:0.792 blue:0.855 alpha:1],
                       [UIColor colorWithRed:0.996 green:0.835 blue:0.129 alpha:1],
                       [UIColor colorWithRed:0.620 green:0.086 blue:0.137 alpha:1]];
    return colorArray;
}

+ (NSArray *)bodyArray {
    if (!bodyArray)
        bodyArray = @[@"0body.png",
                      @"1body.png",
                      @"2body.png",
                      @"3body.png",
                      @"4body.png"];
    return bodyArray;
}

+ (NSArray *)faceArray {
    if (!faceArray)
        faceArray = @[@"face0.png",
                      @"face1.png",
                      @"face2.png",
                      @"face3.png",
                      @"face4.png"];
    return faceArray;
}

+ (NSArray *)descriptionArray {
    if (!descriptionArray)
        descriptionArray = @[
                             @"%@ is a social butterfly. She’s a loyal friend, ready to give you a piggyback ride at a moments notice or greet you with a face lick and wiggle.",
                             @"Creative and contagiously happy, %@ has boundless energy and an appetite for learning about new things. He is vivacious and popular, and is always ready for the next adventure.",
                             @"%@ prefers to work alone and is impatient with hierarchies and politics.  Although he’s not particularly social, he has a razor sharp wit (and claws), and is actually very fun to be around.",
                             @"Independent and ferocious, %@ experiences life at 100 mph. Not interested in maintaining order, he is a fierce individual who is highly effective, successful, and incredibly powerful.",
                             @"Peaceful, shy, and easygoing, %@ takes things at her own pace and lives moment to moment. She is considerate, pleasant, caring, and introspective. She’s a bit nerdy and quiet -- but that’s why everyone loves her."
                             ];
    
    return descriptionArray;
}

+ (UIColor *)colorForIndex:(NSInteger)index {
    return [[self colorArray] objectAtIndex:index];
}

+ (NSString *)descriptionForIndex:(NSInteger)index {
    NSString *description = [[self descriptionArray] objectAtIndex:index];
    return description;
}

+ (UIImage *)imageForBody:(NSInteger)index {
    NSString *imageName = [[self bodyArray] objectAtIndex:index];
    return [UIImage imageNamed:imageName];
}

+ (NSInteger)sizeOfBodyArray {
    return [[self bodyArray] count];
}

+ (UIImage *)imageForFace:(NSInteger)index {
    NSString *imageName = [[self faceArray] objectAtIndex:index];
    return [UIImage imageNamed:imageName];
}

+ (NSInteger)sizeOfFaceArray {
    return [[self faceArray] count];
}

@end
