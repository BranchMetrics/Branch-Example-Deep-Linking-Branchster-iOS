//
//  MonsterViewerViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

#import "BranchInfoViewController.h"
#import "NetworkProgressBar.h"
#import "MonsterViewerViewController.h"
#import "MonsterPartsFactory.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface MonsterViewerViewController () /*<UITextViewDelegate>*/


@property (strong, nonatomic) NSMutableDictionary *viewingMonster;

@property (strong, nonatomic) NetworkProgressBar *progressBar;

@property (strong, nonatomic) NSString *monsterName;
@property (strong, nonatomic) NSString *monsterDescription;

@property (weak, nonatomic) IBOutlet UIView *botLayerOneColor;
@property (weak, nonatomic) IBOutlet UIImageView *botLayerTwoBody;
@property (weak, nonatomic) IBOutlet UIImageView *botLayerThreeFace;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtDescription;


@property (weak, nonatomic) IBOutlet UIButton *cmdChange;
@property (weak, nonatomic) IBOutlet UIButton *cmdInfo;



@property (weak, nonatomic) IBOutlet UITextView *shareTextView;
@property NSString *shareURL;
@end

@implementation MonsterViewerViewController

static CGFloat MONSTER_HEIGHT = 0.4f;



- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.botLayerOneColor setBackgroundColor:[MonsterPartsFactory colorForIndex:[[self.viewingMonster valueForKey:@"color_index"] integerValue]]];
    [self.botLayerTwoBody setImage:[MonsterPartsFactory imageForBody:[[self.viewingMonster valueForKey:@"body_index"] integerValue]]];
    [self.botLayerThreeFace setImage:[MonsterPartsFactory imageForFace:[[self.viewingMonster valueForKey:@"face_index"] integerValue]]];
    
    self.monsterName = [self.viewingMonster valueForKey:@"monster_name"];
    self.monsterDescription = [self.viewingMonster valueForKey:@"monster_description"];
    
    [self.txtName setText:self.monsterName];
    [self.txtDescription setText:self.monsterDescription];

    [self.cmdChange.layer setCornerRadius:3.0];
    [self.cmdInfo.layer setCornerRadius:3.0];
    
    self.progressBar = [[NetworkProgressBar alloc] initWithFrame:self.view.frame andMessage:@"preparing your Branchster.."];
    [self.progressBar show];
    [self.view addSubview:self.progressBar];
    
    [self.progressBar hide];
    [self setViewingMonster:self.viewingMonster];  //not awesome, but it triggers the setter
}



-(void) setViewingMonster: (NSMutableDictionary *)monster {
    _viewingMonster = monster;
    
    [monster setValue:[NSString stringWithFormat:@"My Branchster: %@", self.monsterName] forKey:@"$og_title"];
    [monster setValue:self.monsterDescription forKey:@"$og_description"];
    [monster setValue:[NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png",
                       (short)[[self.viewingMonster valueForKey:@"color_index"] integerValue],
                       (short)[[self.viewingMonster valueForKey:@"body_index"] integerValue],
                       (short)[[self.viewingMonster valueForKey:@"face_index"] integerValue]]
               forKey:@"$og_image_url"];
}

-(IBAction)shareSheet:(id)sender {
//    [self.viewingMonster
//     showShareSheetWithShareText:@"Share Your Monster!"
//     andCallback:nil];[UIMenuController sharedMenuController].menuVisible = NO;
    [self.shareTextView resignFirstResponder];
}


-(IBAction)copyShareURL:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareTextView.text;
}


- (IBAction)cmdChangeClick:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [self adjustMonsterPicturesForScreenSize];
}

- (void)adjustMonsterPicturesForScreenSize {
    [self.botLayerOneColor setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.botLayerTwoBody setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.botLayerThreeFace setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.txtDescription setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cmdChange setTranslatesAutoresizingMaskIntoConstraints:NO];

    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat widthRatio = self.botLayerOneColor.frame.size.width/self.botLayerOneColor.frame.size.height;
    CGFloat newHeight = screenSize.size.height;
        newHeight = newHeight * MONSTER_HEIGHT;
    CGFloat newWidth = widthRatio * newHeight;
    CGRect newFrame = CGRectMake((screenSize.size.width-newWidth)/2, self.botLayerOneColor.frame.origin.y, newWidth, newHeight);
    
    self.botLayerOneColor.frame = newFrame;
    self.botLayerTwoBody.frame = newFrame;
    self.botLayerThreeFace.frame = newFrame;
    
    CGRect textFrame = self.txtDescription.frame;
    textFrame.origin.y  = newFrame.origin.y + newFrame.size.height + 8;
    self.txtDescription.frame = textFrame;
    
    CGRect cmdFrame = self.cmdChange.frame;
        cmdFrame.origin.x = newFrame.origin.x + newFrame.size.width;
    self.cmdChange.frame = cmdFrame;
    [self.view layoutSubviews];
}





@end
