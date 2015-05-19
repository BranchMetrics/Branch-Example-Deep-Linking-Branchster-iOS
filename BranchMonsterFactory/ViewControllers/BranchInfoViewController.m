//
//  BranchInfoViewController.m
//  BranchMonsterFactory
//
//  Created by Sahil Verma on 5/18/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchInfoViewController.h"

@interface BranchInfoViewController ()

@end

@implementation BranchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons

-(IBAction)doneTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goToWebTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://branch.io"];
    [[UIApplication sharedApplication]openURL:url];
}
@end
