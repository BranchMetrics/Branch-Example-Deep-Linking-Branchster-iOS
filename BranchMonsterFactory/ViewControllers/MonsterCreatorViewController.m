//
//  MonsterCreatorViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "MonsterCreatorViewController.h"
#import "MonsterPartsFactory.h"
#import "ImageCollectionViewCell.h"
#import "MonsterViewerViewController.h"
#import "BranchUniversalObject+MonsterHelpers.h"
#import "Branch.h"

@interface MonsterCreatorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *monsterName;

@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UIImageView *bodyView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;
@property (weak, nonatomic) IBOutlet UIButton *cmdRightArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdLeftArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdUpArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdDownArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdDone;

@property (nonatomic) NSInteger bodyIndex;
@property (nonatomic) NSInteger faceIndex;
@end

#pragma mark - MonsterCreatorViewController

@implementation MonsterCreatorViewController

static CGFloat MONSTER_HEIGHT = 0.35f;
//static CGFloat MONSTER_HEIGHT_FIVE = 0.45f;
static CGFloat SIDE_SPACE = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < [self.colorViews count]; i++) {
        UIView *currView = [self.colorViews objectAtIndex:i];
        [currView setBackgroundColor:[MonsterPartsFactory colorForIndex:i]];
        if (i == [self.editingMonster getColorIndex])
            [currView.layer setBorderWidth:2.0f];
        else
            [currView.layer setBorderWidth:0.0f];
        [currView.layer setBorderColor:[UIColor colorWithWhite:0.3 alpha:1.0].CGColor];
        [currView.layer setCornerRadius:currView.frame.size.width/2];
    }
        
    [self.cmdDone.layer setCornerRadius:3.0f];
    
    [self.bodyView setBackgroundColor:[MonsterPartsFactory colorForIndex:[self.editingMonster getColorIndex]]];
    
    [self.monsterName setText:[self.editingMonster getMonsterName]];
    [self.monsterName addTarget:self.monsterName
                      action:@selector(resignFirstResponder)
            forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidLayoutSubviews {
    [self adjustMonsterPicturesForScreenSize];
 
    self.bodyIndex = [self.editingMonster getBodyIndex];
    self.faceIndex = [self.editingMonster getFaceIndex];
    
    // TODO: update monster here
    //[self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //[self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

- (void)adjustMonsterPicturesForScreenSize {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat widthRatio = self.faceView.frame.size.width/self.faceView.frame.size.height;
    CGFloat newHeight = screenSize.size.height;
    //    if (IS_IPHONE_5)
    //        newHeight = newHeight * MONSTER_HEIGHT_FIVE;
    //    else
    newHeight = newHeight * MONSTER_HEIGHT;
    CGFloat newWidth = widthRatio * newHeight;
    CGRect newFrame = CGRectMake((screenSize.size.width-newWidth)/2, self.faceView.frame.origin.y, newWidth, newHeight);
    
    [self.view bringSubviewToFront:self.faceView];
    self.faceView.frame = newFrame;
    self.bodyView.frame = newFrame;
    
    CGRect rightRect = self.cmdRightArrow.frame;
    CGRect leftRect = self.cmdLeftArrow.frame;
    rightRect.origin.y = self.faceView.frame.origin.y + (self.faceView.frame.size.height-rightRect.size.height)/2;
    rightRect.origin.x = self.faceView.frame.origin.x + self.faceView.frame.size.width + SIDE_SPACE;
    leftRect.origin.y = rightRect.origin.y;
    leftRect.origin.x = self.faceView.frame.origin.x - SIDE_SPACE - leftRect.size.width;
    self.cmdRightArrow.frame = rightRect;
    self.cmdLeftArrow.frame = leftRect;
    
    CGRect upRect = self.cmdUpArrow.frame;
    CGRect botRect = self.cmdDownArrow.frame;
    upRect.origin.x = (screenSize.size.width - botRect.size.width)/2;
    upRect.origin.y = self.faceView.frame.origin.y - (upRect.size.height + SIDE_SPACE);
    botRect.origin.x = (screenSize.size.width - botRect.size.width)/2;
    botRect.origin.y = self.faceView.frame.size.height + self.faceView.frame.origin.y + SIDE_SPACE;
    self.cmdUpArrow.frame = upRect;
    self.cmdDownArrow.frame = botRect;
}

- (void)updateFaceWithImage:(UIImage *)image {
    [UIView transitionWithView:self.faceView duration:0.12 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.faceView.image = image;
    } completion:nil];
}

- (void)updateBodyWithImage:(UIImage *)image {
    [UIView transitionWithView:self.bodyView duration:0.12 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.bodyView.image = image;
    } completion:nil];
}

- (IBAction)cmdLeftClick:(id)sender {
    self.bodyIndex = self.bodyIndex - 1;
    if (self.bodyIndex == -1)
        self.bodyIndex = [MonsterPartsFactory sizeOfBodyArray] - 1;
    [self.editingMonster setBodyIndex:self.bodyIndex];
    
    UIImage *bodyImage = [MonsterPartsFactory imageForBody:self.bodyIndex];
    if (bodyImage) {
        [self updateBodyWithImage:bodyImage];
    }
}

- (IBAction)cmdRightClick:(id)sender {
    self.bodyIndex = self.bodyIndex + 1;
    if (self.bodyIndex == [MonsterPartsFactory sizeOfBodyArray])
        self.bodyIndex = 0;
    [self.editingMonster setBodyIndex:self.bodyIndex];
    
    UIImage *bodyImage = [MonsterPartsFactory imageForBody:self.bodyIndex];
    if (bodyImage) {
        [self updateBodyWithImage:bodyImage];
    }
}

- (IBAction)cmdUpClick:(id)sender {
    self.faceIndex = self.faceIndex - 1;
    if (self.faceIndex == -1)
        self.faceIndex = [MonsterPartsFactory sizeOfFaceArray] - 1;
    [self.editingMonster setFaceIndex:self.faceIndex];
    
    UIImage *faceImage = [MonsterPartsFactory imageForFace:self.faceIndex];
    if (faceImage) {
        [self updateFaceWithImage:faceImage];
    }
}

- (IBAction)cmdDownClick:(id)sender {
    self.faceIndex = self.faceIndex + 1;
    if (self.faceIndex == [MonsterPartsFactory sizeOfFaceArray])
        self.faceIndex = 0;
    [self.editingMonster setFaceIndex:self.faceIndex];
    
    UIImage *faceImage = [MonsterPartsFactory imageForFace:self.faceIndex];
    if (faceImage) {
        [self updateFaceWithImage:faceImage];
    }
}

- (IBAction)cmdColorClick:(id)sender {
    UIButton *currColorButton = (UIButton *)sender;
    
    int selected = 0;
    for (int i = 0; i < [self.colorViews count]; i++) {
        UIButton *button = (UIButton *)[self.colorViews objectAtIndex:i];
        [button.layer setBorderWidth:0.0f];
        if ([button isEqual:currColorButton]) {
            selected = i;
        }
    }
    
    [self.editingMonster setColorIndex:selected];
    [self.bodyView setBackgroundColor:[MonsterPartsFactory colorForIndex:selected]];
    [currColorButton setSelected:YES];
    [currColorButton.layer setBorderWidth:2.0f];
}

- (IBAction)cmdFinishedClick:(id)sender {
    if ([self.monsterName.text length]) {
        [self.editingMonster setMonsterName:[self.monsterName text]];
    } else {
        [self.editingMonster setMonsterName:@"Bingles Jingleheimer"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MonsterViewerViewController *receiver = (MonsterViewerViewController *)[segue destinationViewController];
    [receiver setViewingMonster:self.editingMonster];
}

@end
