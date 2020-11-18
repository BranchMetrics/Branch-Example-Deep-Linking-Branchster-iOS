//
//  BranchInfoViewController.m
//  BranchMonsterFactory
//
//  Created by Sahil Verma on 5/18/15.
//  Copyright (c) 2015 Branch. All rights reserved.
//

#import "BranchInfoViewController.h"
#import "BranchAdNetwork.h"
@import Branch;
@import StoreKit;

@interface BranchInfoViewController ()
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
//@property (nonatomic, strong, readwrite) SKStoreProductViewController *productVC;
@end

@implementation BranchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.versionLabel.text =
        [NSString stringWithFormat:@"%@ / %@",
            [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
            BNC_SDK_VERSION];
}

- (IBAction)doneTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToWebTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://branch.io"];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)showDeviceFinder:(id)sender {
    NSString *source = @"0";
    NSString *target = @"1477763736";
    
    BranchAdNetwork *adNetwork = [BranchAdNetwork new];
    [adNetwork requestAttributionWithSource:source target:target completion:^(NSMutableDictionary * _Nonnull params) {
        // add the target app, or
        NSMutableDictionary *tmp = params ? params : [NSMutableDictionary new];
        if (tmp) {
            [tmp setObject:target forKey:SKStoreProductParameterITunesItemIdentifier];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openStoreWithParams:tmp];
        });
    }];
}

- (void)openStoreWithParams:(NSDictionary *)params {
    SKStoreProductViewController *productVC = [SKStoreProductViewController new];
    productVC = [SKStoreProductViewController new];
    [productVC loadProductWithParameters:params completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (result) {
            [self presentViewController:productVC animated:YES completion:^{

            }];
        }
    }];
}

@end
