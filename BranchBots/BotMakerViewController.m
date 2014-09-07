//
//  BotMakerViewController.m
//  BranchBots
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch. All rights reserved.
//

#import "BotMakerViewController.h"
#import "RobotPreferences.h"
#import "RobotPartsFactory.h"
#import "ImageCollectionViewCell.h"

@interface BotMakerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *etxtName;

@property (weak, nonatomic) IBOutlet UIView *botViewLayerOne;
@property (weak, nonatomic) IBOutlet UICollectionView *botViewLayerTwo;
@property (weak, nonatomic) IBOutlet UICollectionView *botViewLayerThree;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;
@property (weak, nonatomic) IBOutlet UIButton *cmdRightArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdLeftArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdDownArrow;

@property (nonatomic) NSInteger bodyIndex;
@property (nonatomic) NSInteger faceIndex;

@end

@implementation BotMakerViewController

static CGFloat MONSTER_HEIGHT = 0.35f;
static CGFloat SIDE_SPACE = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 0; i < [self.colorViews count]; i++) {
        UIView *currView = [self.colorViews objectAtIndex:i];
        [currView setBackgroundColor:[RobotPartsFactory colorForIndex:i]];
        [currView.layer setBorderWidth:0.0f];
        [currView.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    }
    [self.botViewLayerOne setBackgroundColor:[RobotPartsFactory colorForIndex:[RobotPreferences getColorIndex]]];
    
    self.botViewLayerTwo.delegate = self;
    self.botViewLayerTwo.dataSource = self;
    [self.botViewLayerTwo registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.botViewLayerThree.delegate = self;
    self.botViewLayerThree.dataSource = self;
    [self.botViewLayerThree registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.etxtName action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    self.etxtName.inputAccessoryView = toolbar;
}

- (void)viewDidLayoutSubviews {
    [self adjustMonsterPicturesForScreenSize];
    
    self.bodyIndex = [RobotPreferences getBodyIndex];
    self.faceIndex = [RobotPreferences getFaceIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

- (void)adjustMonsterPicturesForScreenSize {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat widthRatio = self.botViewLayerOne.frame.size.width/self.botViewLayerOne.frame.size.height;
    CGFloat newHeight = screenSize.size.height * MONSTER_HEIGHT;
    CGFloat newWidth = widthRatio * newHeight;
    CGRect newFrame = CGRectMake((screenSize.size.width-newWidth)/2, self.botViewLayerOne.frame.origin.y, newWidth, newHeight);
    
    self.botViewLayerOne.frame = newFrame;
    self.botViewLayerTwo.frame = newFrame;
    self.botViewLayerThree.frame = newFrame;
    
    CGRect rightRect = self.cmdRightArrow.frame;
    CGRect leftRect = self.cmdLeftArrow.frame;
    rightRect.origin.y = self.botViewLayerOne.frame.origin.y + (self.botViewLayerOne.frame.size.height-rightRect.size.height)/2;
    rightRect.origin.x = self.botViewLayerOne.frame.origin.x + self.botViewLayerOne.frame.size.width + SIDE_SPACE;
    leftRect.origin.y = rightRect.origin.y;
    leftRect.origin.x = self.botViewLayerOne.frame.origin.x - SIDE_SPACE - leftRect.size.width;
    self.cmdRightArrow.frame = rightRect;
    self.cmdLeftArrow.frame = leftRect;
    
    CGRect botRect = self.cmdDownArrow.frame;
    botRect.origin.x = (screenSize.size.width - botRect.size.width)/2;
    botRect.origin.y = self.botViewLayerOne.frame.size.height + self.botViewLayerOne.frame.origin.y + SIDE_SPACE;
    self.cmdDownArrow.frame = botRect;
}

- (IBAction)cmdLeftClick:(id)sender {
    self.bodyIndex = MAX(0, self.bodyIndex-1);
    [RobotPreferences setBodyIndex:self.bodyIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (IBAction)cmdRightClick:(id)sender {
    self.bodyIndex = MIN([RobotPartsFactory sizeOfBodyArray]-1, self.bodyIndex+1);
    [RobotPreferences setBodyIndex:self.bodyIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (IBAction)cmdUpClick:(id)sender {
    self.faceIndex = MAX(0, self.faceIndex-1);
    [RobotPreferences setFaceIndex:self.faceIndex];
    [self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}
- (IBAction)cmdDownClick:(id)sender {
    self.faceIndex = MIN([RobotPartsFactory sizeOfFaceArray]-1, self.faceIndex+1);
    [RobotPreferences setFaceIndex:self.faceIndex];
    [self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
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
    
    [RobotPreferences setColorIndex:selected];
    [self.botViewLayerOne setBackgroundColor:[RobotPartsFactory colorForIndex:selected]];
    [currColorButton setSelected:YES];
    [currColorButton.layer setBorderWidth:2.0f];
}

- (IBAction)cmdFinishedClick:(id)sender {
    if ([self.etxtName.text length]) {
        [RobotPreferences setRobotName:self.etxtName.text];
    } else {
        [RobotPreferences setRobotName:@"Bingles Jingleheimer"];
    }
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"BotViewerViewController"] animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.botViewLayerTwo]) {
        return [RobotPartsFactory sizeOfBodyArray];
    } else {
        return [RobotPartsFactory sizeOfFaceArray];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.botViewLayerOne.frame.size.width, self.botViewLayerOne.frame.size.height);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([collectionView isEqual:self.botViewLayerTwo]) {
        UIImage *bodyImage = [RobotPartsFactory imageForBody:indexPath.row];
        [cell.imageView setImage:bodyImage];
    } else {
        UIImage *faceImage = [RobotPartsFactory imageForFace:indexPath.row];
        [cell.imageView setImage:faceImage];
        [cell bringSubviewToFront:cell.imageView];
    }

    return cell;
}

@end
