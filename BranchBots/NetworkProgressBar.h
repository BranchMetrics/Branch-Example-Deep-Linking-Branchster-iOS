//
//  NetworkProgressBar.h
//  KindredPrints
//
//  Created by Alex on 7/29/13.
//  Copyright (c) 2013 Pawprint Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkProgressBar : UIView

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)message;
- (void)showWithMessage:(NSString *)message;
- (void)changeMessageTo:(NSString *)message;
- (void)hide;
- (void)show;

@end
