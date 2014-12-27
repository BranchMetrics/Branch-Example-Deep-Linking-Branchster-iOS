//
//  NetworkProgressBar.m
//  BranchMonsterFactory
//
//  Created by Alex on 9/6/14.
//  Copyright (c) 2014 Branch, Inc. All rights reserved.
//

#import "NetworkProgressBar.h"

@interface NetworkProgressBar()

@property (strong, nonatomic) UILabel *txtMessage;
@property (strong, nonatomic) UIActivityIndicatorView *progBar;

@end

@implementation NetworkProgressBar

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)message
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        self.progBar = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGPoint framePoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 80);
        self.progBar.center = framePoint;
        [self.progBar startAnimating];
        
        self.txtMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, 100)];
        [self.txtMessage setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        [self.txtMessage setFont:[UIFont fontWithName:@"GillSans-Light" size:22]];
        [self.txtMessage setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [self.txtMessage setTextAlignment:NSTextAlignmentCenter];
        [self.txtMessage setNumberOfLines:3];
        [self.txtMessage setText:message];
        
        [self addSubview:self.txtMessage];
        [self addSubview:self.progBar];

        [self setHidden:YES];
    }
    return self;
}

- (void)showWithMessage:(NSString *)message {
    [self.txtMessage setText:message];
    [self setHidden:NO];
}
- (void)changeMessageTo:(NSString *)message {
    [self.txtMessage setText:message];
}

- (void)show {
    [self setHidden:YES];
}

- (void)hide {
    [self setHidden:YES];
}

@end
