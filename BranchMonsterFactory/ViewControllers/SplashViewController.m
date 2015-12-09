//
//  SplashViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "NetworkProgressBar.h"
#import "SplashViewController.h"
#import "MonsterCreatorViewController.h"
#import "MonsterViewerViewController.h"

#import "BranchUniversalObject.h"
#import "AppDelegate.h"

@interface SplashViewController ()

@property BranchUniversalObject *startingMonster;

@property (weak, nonatomic) IBOutlet UIImageView *imgLoading;
@property (weak, nonatomic) IBOutlet UILabel *txtNote;
@property (strong, nonatomic) NSArray *loadingMessages;
@property (nonatomic) NSInteger messageIndex;

@property BOOL firstTime;
@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;


    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pushEditView)
                                                     name:@"pushEditView"
                                                   object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushEditAndViewerViews)
                                                 name:@"pushEditAndViewerViews"
                                               object:nil];

    
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

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}


#pragma mark - Navigation



    //used only for initial launch to blank monster
- (void) pushEditView {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.startingMonster = appDelegate.initialMonster;
    [[self navigationController] popToRootViewControllerAnimated:NO];
    [self performSegueWithIdentifier: @"editMonster" sender: self];
    }


//used for
- (void) pushEditAndViewerViews {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.startingMonster = appDelegate.initialMonster;
    [[self navigationController] popToRootViewControllerAnimated:NO];
    
    MonsterCreatorViewController  *creator = [self.storyboard instantiateViewControllerWithIdentifier:@"MonsterCreatorViewController"];
    creator.editingMonster = self.startingMonster;
    [self.navigationController pushViewController:creator animated:NO];
    
    //now do the same with the monsterviewercontroller, but with animation, so they are on the stack in the correct order
    MonsterViewerViewController  *viewer = [self.storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
    viewer.viewingMonster = self.startingMonster;
    [self.navigationController pushViewController:viewer animated:YES];

}












// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MonsterCreatorViewController *receiver = (MonsterCreatorViewController *)[segue destinationViewController];
    receiver.editingMonster = self.startingMonster;
}


- (void) dealloc
{
    // will continue to send notification objects to the deallocate object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
