//
//  BranchInfoViewController.m
//  BranchMonsterFactory
//
//  Created by Sahil Verma on 5/18/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchInfoViewController.h"
@import Branch;

@interface BranchInfoViewController ()
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@end

@implementation BranchInfoViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.versionLabel.text =
        [NSString stringWithFormat:@"%@ / %@",
            [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
            BNC_SDK_VERSION];
}

-(IBAction)doneTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goToWebTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://branch.io"];
    [[UIApplication sharedApplication]openURL:url];
}

@end
