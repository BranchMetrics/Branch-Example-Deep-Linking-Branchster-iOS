//
//  SplashViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "NetworkProgressBar.h"
#import "SplashViewController.h"

@interface SplashViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLoading;
@property (weak, nonatomic) IBOutlet UILabel *txtNote;
@property (strong, nonatomic) NSArray *loadingMessages;
@property (nonatomic) NSInteger messageIndex;
@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(2*M_PI);
    animation.duration = 1.9f;             // this might be too fast
    animation.repeatCount = HUGE_VALF;     // HUGE_VALF is defined in math.h so import it
    [self.imgLoading.layer addAnimation:animation forKey:@"rotation"];
    
    self.loadingMessages = @[@"Loading Branchster parts",
                             @"Loading Branchster parts.",
                             @"Loading Branchster parts..",
                             @"Loading Branchster parts..."];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3
                                     target:self
                                   selector:@selector(updateMessageIndex)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidLayoutSubviews {
    [self.navigationController.navigationBar setHidden:YES];
}

- (void) updateMessageIndex {
    self.messageIndex = (self.messageIndex + 1)%[self.loadingMessages count];
    [self.txtNote setText:[self.loadingMessages objectAtIndex:self.messageIndex]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
