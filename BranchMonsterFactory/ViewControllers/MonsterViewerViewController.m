//
//  MonsterViewerViewController.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

@import BranchSDK;
#import "BranchUniversalObject+MonsterHelpers.h"
#import "BranchInfoViewController.h"
#import "NetworkProgressBar.h"
#import "MonsterViewerViewController.h"
#import "MonsterPartsFactory.h"

@interface MonsterViewerViewController () /*<UITextViewDelegate>*/

@property (strong, nonatomic)BranchUniversalObject *viewingMonster;
@property (strong, nonatomic) NetworkProgressBar *progressBar;
@property (strong, nonatomic) NSDictionary *monsterMetadata;

@property (strong, nonatomic) NSString *monsterName;
@property (strong, nonatomic) NSString *monsterDescription;
@property (strong, nonatomic) NSDecimalNumber *price;

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

#pragma mark - MonsterViewerViewController

@implementation MonsterViewerViewController

static CGFloat MONSTER_HEIGHT = 0.4f;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.botLayerOneColor setBackgroundColor:[MonsterPartsFactory colorForIndex:[self.viewingMonster getColorIndex]]];
    [self.botLayerTwoBody setImage:[MonsterPartsFactory imageForBody:[self.viewingMonster getBodyIndex]]];
    [self.botLayerThreeFace setImage:[MonsterPartsFactory imageForFace:[self.viewingMonster getFaceIndex]]];
    
    self.monsterName = [self.viewingMonster getMonsterName];
    if (!self.monsterName) self.monsterName = @"None";

    NSInteger priceInt = arc4random_uniform(4) + 1;
    NSString *priceString = [NSString stringWithFormat:@"%1.2f", (float)priceInt];
    _price = [NSDecimalNumber decimalNumberWithString:priceString];

    self.monsterDescription = [self.viewingMonster getMonsterDescription];
    
    [self.txtName setText:self.monsterName];
    [self.txtDescription setText:self.monsterDescription];
    
    self.monsterMetadata = [[NSDictionary alloc]
                            initWithObjects:@[
                                              [NSNumber numberWithInteger:[self.viewingMonster getColorIndex]],
                                              [NSNumber numberWithInteger:[self.viewingMonster getBodyIndex]],
                                              [NSNumber numberWithInteger:[self.viewingMonster getFaceIndex]],
                                              self.monsterName]
                            forKeys:@[
                                      @"color_index",
                                      @"body_index",
                                      @"face_index",
                                      @"monster_name"]];

    [self.cmdChange.layer setCornerRadius:3.0];
    [self.cmdInfo.layer setCornerRadius:3.0];
    
    self.progressBar = [[NetworkProgressBar alloc] initWithFrame:self.view.frame andMessage:@"preparing your Branchster.."];
    [self.progressBar show];
    [self.view addSubview:self.progressBar];
    
    
    [self.viewingMonster registerViewWithCallback:^(NSDictionary *params, NSError *error) {
        NSLog(@"Monster %@ was viewed.  params: %@", self.viewingMonster.getMonsterName, params);
    }];
    
    [self.progressBar hide];
    [self setViewingMonster:self.viewingMonster];  //not awesome, but it triggers the setter
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.monsterName.length <= 0) self.monsterName = @"Nameless Monster";
    BranchEvent *event = [BranchEvent standardEvent:BranchStandardEventViewItem];
    BranchUniversalObject *buo = [[BranchUniversalObject alloc] init];
    BranchContentMetadata *metadata = [[BranchContentMetadata alloc] init];
    metadata.sku = self.monsterName;
    metadata.price = self.price;
    metadata.currency = @"USD";
    
    buo.contentMetadata = metadata;
    event.contentItems = @[buo];
    [event logEvent];
}

-(void) setViewingMonster: (BranchUniversalObject *)monster {
    _viewingMonster = monster;
    
    //and every time it gets set, I need to create a new url
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"monster_sharing";
    linkProperties.channel = @"twitter";

    monster.title = [NSString stringWithFormat:@"My Branchster: %@", self.monsterName];
    monster.contentDescription = self.monsterDescription;
    monster.imageUrl = [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[self.viewingMonster getColorIndex], (short)[self.viewingMonster getBodyIndex], (short)[self.viewingMonster getFaceIndex]];

    [self.viewingMonster getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *error) {
        if (!error) {
            self.shareURL = url;
            NSLog(@"new monster url created:  %@", self.shareURL);
            self.shareTextView.text = url;
        }
    }];
}

-(IBAction)shareSheet:(id)sender {

    BranchContentMetadata* branchester = [BranchContentMetadata new];
    if (self.monsterName.length <= 0) self.monsterName = @"Nameless Monster";
    branchester.sku = self.monsterName;
    branchester.price = self.price;
    branchester.quantity = 1;
    branchester.productVariant = @"X-Tra Hairy";
    branchester.productBrand = @"Branch";
    branchester.productCategory = BNCProductCategoryAnimalSupplies;
    branchester.productName = self.monsterName;
    BranchUniversalObject *buo = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:@"monster"];
    buo.contentMetadata = branchester;
    
    BranchEvent *commerceEvent = [BranchEvent standardEvent:BNCAddToCartEvent withContentItem:buo];
    commerceEvent.revenue = self.price;
    commerceEvent.currency = @"USD";
    [commerceEvent logEvent];
    
    [self.viewingMonster showShareSheetWithShareText:@"Share Your Monster!" completion:^(NSString * _Nullable activityType, BOOL completed, NSError * _Nullable error) {
        if (completed) {
            [[BranchEvent standardEvent:BNCAddToCartEvent] logEvent];

        }
    }];
    
    [self.shareTextView resignFirstResponder];
}


-(IBAction)copyShareURL:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareTextView.text;
}


- (IBAction)cmdChangeClick:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}


- (NSDictionary *)prepareFBDict:(NSString *)url {
    return [[NSDictionary alloc] initWithObjects:@[
                                                   [NSString stringWithFormat:@"My Branchster: %@", self.monsterName],
                                                   self.monsterDescription,
                                                   self.monsterDescription,
                                                   url,
                                                   [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[self.viewingMonster getColorIndex], (short)[self.viewingMonster getBodyIndex], (short)[self.viewingMonster getFaceIndex]]]
                                         forKeys:@[
                                                   @"name",
                                                   @"caption",
                                                   @"description",
                                                   @"link",
                                                   @"picture"]];
}

// This function serves to dynamically generate the dictionary parameters to embed in the Branch link
// These are the parameters that will be available in the callback of init user session if
// a user clicked the link and was deep linked
- (NSDictionary *)prepareBranchDict {
    return [[NSDictionary alloc] initWithObjects:@[
                                                  [NSNumber numberWithInteger:[self.viewingMonster getColorIndex]],
                                                  [NSNumber numberWithInteger:[self.viewingMonster getBodyIndex]],
                                                  [NSNumber numberWithInteger:[self.viewingMonster getFaceIndex]],
                                                  self.monsterName,
                                                  @"true",
                                                  [NSString stringWithFormat:@"My Branchster: %@", self.monsterName],
                                                  self.monsterDescription,
                                                  [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[self.viewingMonster getColorIndex], (short)[self.viewingMonster getBodyIndex], (short)[self.viewingMonster getFaceIndex]]]
                                        forKeys:@[
                                                  @"color_index",
                                                  @"body_index",
                                                  @"face_index",
                                                  @"monster_name",
                                                  @"monster",
                                                  @"$og_title",
                                                  @"$og_description",
                                                  @"$og_image_url"]];
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
    CGRect newFrame = CGRectMake(
        (screenSize.size.width-newWidth)/2,
        self.botLayerOneColor.frame.origin.y,
        newWidth,
        newHeight
    );
    
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
