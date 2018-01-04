//
//  NetworkProgressBar.h
//  BranchMonsterFactory
//
//  Created by Alex on 9/6/14.
//  Copyright (c) 2014 Branch, Inc. All rights reserved.
//

@import UIKit;

@interface NetworkProgressBar : UIView

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)message;
- (void)showWithMessage:(NSString *)message;
- (void)changeMessageTo:(NSString *)message;
- (void)hide;
- (void)show;

@end
