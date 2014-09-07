//
//  BotViewerViewController.m
//  BranchBots
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch. All rights reserved.
//

#import "NetworkProgressBar.h"
#import "BotViewerViewController.h"
#import "RobotPartsFactory.h"
#import "RobotPreferences.h"
#import "Branch.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface BotViewerViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) NetworkProgressBar *progressBar;

@property (strong, nonatomic) NSDictionary *monsterMetadata;

@property (weak, nonatomic) IBOutlet UIView *botLayerOneColor;
@property (weak, nonatomic) IBOutlet UIImageView *botLayerTwoBody;
@property (weak, nonatomic) IBOutlet UIImageView *botLayerThreeFace;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtDescription;

@property (weak, nonatomic) IBOutlet UIButton *cmdMessage;
@property (weak, nonatomic) IBOutlet UIButton *cmdMail;
@property (weak, nonatomic) IBOutlet UIButton *cmdTwitter;
@property (weak, nonatomic) IBOutlet UIButton *cmdFacebook;

@property (weak, nonatomic) IBOutlet UITextView *etxtUrl;

@property (weak, nonatomic) IBOutlet UIButton *cmdChange;

@end

@implementation BotViewerViewController

static CGFloat MONSTER_HEIGHT = 0.4f;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.botLayerOneColor setBackgroundColor:[RobotPartsFactory colorForIndex:[RobotPreferences getColorIndex]]];
    [self.botLayerTwoBody setImage:[RobotPartsFactory imageForBody:[RobotPreferences getBodyIndex]]];
    [self.botLayerThreeFace setImage:[RobotPartsFactory imageForFace:[RobotPreferences getFaceIndex]]];
    
    [self.view bringSubviewToFront:self.botLayerTwoBody];
    [self.view bringSubviewToFront:self.botLayerThreeFace];
    
    [self.txtName setText:[RobotPreferences getRobotName]];
    [self.txtDescription setText:[RobotPreferences getRobotDescription]];
    
    [self.etxtUrl setTextColor:[UIColor blackColor]];
    
    self.monsterMetadata = [[NSDictionary alloc]
                            initWithObjects:@[
                                              [NSNumber numberWithInt:[RobotPreferences getColorIndex]],
                                              [NSNumber numberWithInt:[RobotPreferences getBodyIndex]],
                                              [NSNumber numberWithInt:[RobotPreferences getFaceIndex]],
                                              [RobotPreferences getRobotName]]
                            forKeys:@[
                                      @"color_index",
                                      @"body_index",
                                      @"face_index",
                                      @"monster_name"]];
    
    self.progressBar = [[NetworkProgressBar alloc] initWithFrame:self.view.frame andMessage:@"preparing your Branchster.."];
    [self.progressBar show];
    [self.view addSubview:self.progressBar];
    
    [[Branch getInstance] userCompletedAction:@"monster_view" withState:self.monsterMetadata];
    
    [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict] andChannel:@"viewer" andCallback:^(NSString *url) {
        [self.etxtUrl setText:url];
        [self.progressBar hide];
    }];
}

- (IBAction)cmdChangeClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSDictionary *)prepareBranchDict {
    return [[NSDictionary alloc] initWithObjects:@[
                                                  [NSNumber numberWithInt:[RobotPreferences getColorIndex]],
                                                  [NSNumber numberWithInt:[RobotPreferences getBodyIndex]],
                                                  [NSNumber numberWithInt:[RobotPreferences getFaceIndex]],
                                                  [RobotPreferences getRobotName],
                                                  @"true",
                                                  [NSString stringWithFormat:@"My Branchster: %@", [RobotPreferences getRobotName]],
                                                  [RobotPreferences getRobotDescription],
                                                  [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%d%d%d.png", [RobotPreferences getColorIndex], [RobotPreferences getBodyIndex], [RobotPreferences getFaceIndex]]]
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
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat widthRatio = self.botLayerOneColor.frame.size.width/self.botLayerOneColor.frame.size.height;
    CGFloat newHeight = screenSize.size.height * MONSTER_HEIGHT;
    CGFloat newWidth = widthRatio * newHeight;
    CGRect newFrame = CGRectMake((screenSize.size.width-newWidth)/2, self.botLayerOneColor.frame.origin.y, newWidth, newHeight);
    
    self.botLayerOneColor.frame = newFrame;
    self.botLayerTwoBody.frame = newFrame;
    self.botLayerThreeFace.frame = newFrame;
}

- (IBAction)cmdMessageClick:(id)sender {
    [[Branch getInstance] userCompletedAction:@"share_message_click" withState:self.monsterMetadata];
    
    if([MFMessageComposeViewController canSendText]){
        [self.progressBar changeMessageTo:@"preparing message.."];
        [self.progressBar show];
        
        MFMessageComposeViewController *smsViewController = [[MFMessageComposeViewController alloc] init];
        smsViewController.messageComposeDelegate = self;
        
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"message_share" andCallback:^(NSString *url) {
            [self.progressBar hide];
            smsViewController.body = [NSString stringWithFormat:@"Check out my Branchster named %@ at %@", [RobotPreferences getRobotName], url];
            [self presentViewController:smsViewController animated:YES completion:nil];
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Message Support" message:@"This device does not support messaging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }

}

- (IBAction)cmdMailClick:(id)sender {
    [[Branch getInstance] userCompletedAction:@"share_mail_click" withState:self.monsterMetadata];
    if ([MFMailComposeViewController canSendMail]) {
        [self.progressBar changeMessageTo:@"preparing mail.."];
        [self.progressBar show];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Check out my Branchster named %@", [RobotPreferences getRobotName]]];
        NSArray *toRecipients = nil;
        [mailer setToRecipients:toRecipients];
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"mail_share" andCallback:^(NSString *url) {
            [self.progressBar hide];
            NSString *emailBody = [NSString stringWithFormat:@"I just created this Branchster named %@ in the Branch Monster Factory.\n\nSee it here:\n%@", [RobotPreferences getRobotName], url];
            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentViewController:mailer animated:YES completion:nil];
        }];
        
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Mail Support" message:@"Your default mail client is not configured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdTwitterClick:(id)sender {
    [[Branch getInstance] userCompletedAction:@"share_twitter_click" withState:self.monsterMetadata];
    
    SLComposeViewController *twitterController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result) {
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            switch(result){
                case SLComposeViewControllerResultDone:
                    [[Branch getInstance] userCompletedAction:@"share_twitter_success"];
                    break;
                case SLComposeViewControllerResultCancelled:
                default:
                    break;
            }
        };
        
        [self.progressBar changeMessageTo:@"preparing post.."];
        [self.progressBar show];
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"twitter_share" andCallback:^(NSString *url) {
            [self.progressBar hide];
            [twitterController setInitialText:[NSString stringWithFormat:@"Check out my Branchster named %@", [RobotPreferences getRobotName]]];
            [twitterController addURL:[NSURL URLWithString:url]];
            [twitterController setCompletionHandler:completionHandler];
            [self presentViewController:twitterController animated:YES completion:nil];
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Twitter Account" message:@"You do not seem to have Facebook on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdFacebookClick:(id)sender {
    [[Branch getInstance] userCompletedAction:@"share_facebook_click" withState:self.monsterMetadata];
    
    SLComposeViewController *fbController= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewControllerCompletionHandler completionHandler = ^(SLComposeViewControllerResult result) {
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultDone:
                    [[Branch getInstance] userCompletedAction:@"share_facebook_success"];
                    break;
                case SLComposeViewControllerResultCancelled:
                default:
                    break;
            }
        };
        
        [self.progressBar changeMessageTo:@"preparing post.."];
        [self.progressBar show];
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"facebook_share" andCallback:^(NSString *url) {
            [self.progressBar hide];
            [fbController setInitialText:[NSString stringWithFormat:@"Check out my Branchster named %@", [RobotPreferences getRobotName]]];
            [fbController addURL:[NSURL URLWithString:url]];
            [fbController setCompletionHandler:completionHandler];
            [self presentViewController:fbController animated:YES completion:nil];
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Facebook Account" message:@"You do not seem to have Facebook on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (MessageComposeResultSent == result) {
        [[Branch getInstance] userCompletedAction:@"share_message_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (MFMailComposeResultSent == result) {
        [[Branch getInstance] userCompletedAction:@"share_mail_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
