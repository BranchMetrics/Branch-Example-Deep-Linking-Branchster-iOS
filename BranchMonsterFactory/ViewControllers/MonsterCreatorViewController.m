//
//  MonsterCreatorViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "MonsterCreatorViewController.h"
#import "MonsterPreferences.h"
#import "MonsterPartsFactory.h"
#import "ImageCollectionViewCell.h"
#import "Branch.h"

@interface MonsterCreatorViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *etxtName;

@property (weak, nonatomic) IBOutlet UIView *botViewLayerOne;
@property (weak, nonatomic) IBOutlet UICollectionView *botViewLayerTwo;
@property (weak, nonatomic) IBOutlet UICollectionView *botViewLayerThree;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;
@property (weak, nonatomic) IBOutlet UIButton *cmdRightArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdLeftArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdDownArrow;
@property (weak, nonatomic) IBOutlet UIButton *cmdDone;

@property (nonatomic) NSInteger bodyIndex;
@property (nonatomic) NSInteger faceIndex;

@end

@implementation MonsterCreatorViewController

static CGFloat MONSTER_HEIGHT = 0.35f;
static CGFloat MONSTER_HEIGHT_FIVE = 0.45f;
static CGFloat SIDE_SPACE = 7.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 0; i < [self.colorViews count]; i++) {
        UIView *currView = [self.colorViews objectAtIndex:i];
        [currView setBackgroundColor:[MonsterPartsFactory colorForIndex:i]];
        if (i == [MonsterPreferences getColorIndex])
            [currView.layer setBorderWidth:2.0f];
        else
            [currView.layer setBorderWidth:0.0f];
        [currView.layer setBorderColor:[UIColor colorWithWhite:0.3 alpha:1.0].CGColor];
        [currView.layer setCornerRadius:currView.frame.size.width/2];
    }
    
    [self.cmdDone.layer setCornerRadius:3.0f];
    
    [self.botViewLayerOne setBackgroundColor:[MonsterPartsFactory colorForIndex:[MonsterPreferences getColorIndex]]];
    
    self.botViewLayerTwo.delegate = self;
    self.botViewLayerTwo.dataSource = self;
    [self.botViewLayerTwo registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.botViewLayerThree.delegate = self;
    self.botViewLayerThree.dataSource = self;
    [self.botViewLayerThree registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.etxtName setText:[MonsterPreferences getMonsterName]];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.etxtName action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    // track that the user viewed the monster edit page
    [[Branch getInstance] userCompletedAction:@"monster_edit"];
    
    self.etxtName.inputAccessoryView = toolbar;
    [self.etxtName addTarget:self.etxtName
                      action:@selector(resignFirstResponder)
            forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidLayoutSubviews {
    [self adjustMonsterPicturesForScreenSize];
    
    self.bodyIndex = [MonsterPreferences getBodyIndex];
    self.faceIndex = [MonsterPreferences getFaceIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

- (void)adjustMonsterPicturesForScreenSize {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat widthRatio = self.botViewLayerOne.frame.size.width/self.botViewLayerOne.frame.size.height;
    CGFloat newHeight = screenSize.size.height;
    if (IS_IPHONE_5)
        newHeight = newHeight * MONSTER_HEIGHT_FIVE;
    else
        newHeight = newHeight * MONSTER_HEIGHT;
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
    self.bodyIndex = self.bodyIndex - 1;
    if (self.bodyIndex == -1)
        self.bodyIndex = [MonsterPartsFactory sizeOfBodyArray] - 1;
    [MonsterPreferences setBodyIndex:self.bodyIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (IBAction)cmdRightClick:(id)sender {
    self.bodyIndex = self.bodyIndex + 1;
    if (self.bodyIndex == [MonsterPartsFactory sizeOfBodyArray])
        self.bodyIndex = 0;
    [MonsterPreferences setBodyIndex:self.bodyIndex];
    [self.botViewLayerTwo scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.bodyIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (IBAction)cmdUpClick:(id)sender {
    self.faceIndex = self.faceIndex - 1;
    if (self.faceIndex == -1)
        self.faceIndex = [MonsterPartsFactory sizeOfFaceArray] - 1;
    [MonsterPreferences setFaceIndex:self.faceIndex];
    [self.botViewLayerThree scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.faceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}
- (IBAction)cmdDownClick:(id)sender {
    self.faceIndex = self.faceIndex + 1;
    if (self.faceIndex == [MonsterPartsFactory sizeOfFaceArray])
        self.faceIndex = 0;
    [MonsterPreferences setFaceIndex:self.faceIndex];
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
    
    [MonsterPreferences setColorIndex:selected];
    [self.botViewLayerOne setBackgroundColor:[MonsterPartsFactory colorForIndex:selected]];
    [currColorButton setSelected:YES];
    [currColorButton.layer setBorderWidth:2.0f];
}

- (IBAction)cmdFinishedClick:(id)sender {
    if ([self.etxtName.text length]) {
        [MonsterPreferences setMonsterName:[self.etxtName text]];
    } else {
        [MonsterPreferences setMonsterName:@"Bingles Jingleheimer"];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.botViewLayerTwo]) {
        return [MonsterPartsFactory sizeOfBodyArray];
    } else {
        return [MonsterPartsFactory sizeOfFaceArray];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.botViewLayerOne.frame.size.width, self.botViewLayerOne.frame.size.height);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([collectionView isEqual:self.botViewLayerTwo]) {
        UIImage *bodyImage = [MonsterPartsFactory imageForBody:indexPath.row];
        [cell.imageView setImage:bodyImage];
    } else {
        UIImage *faceImage = [MonsterPartsFactory imageForFace:indexPath.row];
        [cell.imageView setImage:faceImage];
        [cell bringSubviewToFront:cell.imageView];
    }

    return cell;
}

@end
