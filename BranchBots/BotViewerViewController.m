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
#import <FacebookSDK/FacebookSDK.h>

@interface BotViewerViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) NetworkProgressBar *progressBar;

@property (strong, nonatomic) NSDictionary *monsterMetadata;

@property (strong, nonatomic) NSString *monsterName;
@property (strong, nonatomic) NSString *monsterDescription;

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
static CGFloat MONSTER_HEIGHT_FIVE = 0.55f;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.botLayerOneColor setBackgroundColor:[RobotPartsFactory colorForIndex:[RobotPreferences getColorIndex]]];
    [self.botLayerTwoBody setImage:[RobotPartsFactory imageForBody:[RobotPreferences getBodyIndex]]];
    [self.botLayerThreeFace setImage:[RobotPartsFactory imageForFace:[RobotPreferences getFaceIndex]]];
    
    self.monsterName = [RobotPreferences getRobotName];
    self.monsterDescription = [RobotPreferences getRobotDescription];
    
    [self.txtName setText:self.monsterName];
    [self.txtDescription setText:self.monsterDescription];
    
    [self.etxtUrl setTextColor:[UIColor blackColor]];
    
    self.monsterMetadata = [[NSDictionary alloc]
                            initWithObjects:@[
                                              [NSNumber numberWithInteger:[RobotPreferences getColorIndex]],
                                              [NSNumber numberWithInteger:[RobotPreferences getBodyIndex]],
                                              [NSNumber numberWithInteger:[RobotPreferences getFaceIndex]],
                                              self.monsterName]
                            forKeys:@[
                                      @"color_index",
                                      @"body_index",
                                      @"face_index",
                                      @"monster_name"]];
    
    [self.cmdChange.layer setCornerRadius:3.0];
    
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
    if ([[self.navigationController viewControllers] count] > 1)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController setViewControllers:@[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BotMakerViewController"]] animated:YES];
}


- (NSDictionary *)prepareFBDict:(NSString *)url {
    return [[NSDictionary alloc] initWithObjects:@[
                                                   [NSString stringWithFormat:@"My Branchster: %@", self.monsterName],
                                                   self.monsterDescription,
                                                   self.monsterDescription,
                                                   url,
                                                   [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[RobotPreferences getColorIndex], (short)[RobotPreferences getBodyIndex], (short)[RobotPreferences getFaceIndex]]]
                                         forKeys:@[
                                                   @"name",
                                                   @"caption",
                                                   @"description",
                                                   @"link",
                                                   @"picture"]];
}


- (NSDictionary *)prepareBranchDict {
    return [[NSDictionary alloc] initWithObjects:@[
                                                  [NSNumber numberWithInteger:[RobotPreferences getColorIndex]],
                                                  [NSNumber numberWithInteger:[RobotPreferences getBodyIndex]],
                                                  [NSNumber numberWithInteger:[RobotPreferences getFaceIndex]],
                                                  self.monsterName,
                                                  @"true",
                                                  [NSString stringWithFormat:@"My Branchster: %@", self.monsterName],
                                                  self.monsterDescription,
                                                  [NSString stringWithFormat:@"https://s3-us-west-1.amazonaws.com/branchmonsterfactory/%hd%hd%hd.png", (short)[RobotPreferences getColorIndex], (short)[RobotPreferences getBodyIndex], (short)[RobotPreferences getFaceIndex]]]
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
    if (IS_IPHONE_5)
        newHeight = newHeight * MONSTER_HEIGHT_FIVE;
    else
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
    if (IS_IPHONE_5)
        cmdFrame.origin.x = newFrame.origin.x + newFrame.size.width - cmdFrame.size.width/2;
    else
        cmdFrame.origin.x = newFrame.origin.x + newFrame.size.width;
    self.cmdChange.frame = cmdFrame;
    [self.view layoutSubviews];
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
            smsViewController.body = [NSString stringWithFormat:@"Check out my Branchster named %@ at %@", self.monsterName, url];
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
        [mailer setSubject:[NSString stringWithFormat:@"Check out my Branchster named %@", self.monsterName]];
        NSArray *toRecipients = nil;
        [mailer setToRecipients:toRecipients];
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"mail_share" andCallback:^(NSString *url) {
            [self.progressBar hide];
            NSString *emailBody = [NSString stringWithFormat:@"I just created this Branchster named %@ in the Branch Monster Factory.\n\nSee it here:\n%@", self.monsterName, url];
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
            [twitterController setInitialText:[NSString stringWithFormat:@"Check out my Branchster named %@", self.monsterName]];
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
    
    [self.progressBar changeMessageTo:@"preparing post.."];
    [self.progressBar show];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound) {
        [self initiateFacebookShare];
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions",
                                nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
        }];
    }
    
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    switch (state)
    {   case FBSessionStateOpen:
            [self initiateFacebookShare];
            break;
        case FBSessionStateClosed:
            [self.progressBar hide];
            break;
        case FBSessionStateClosedLoginFailed:
            [self.progressBar hide];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            [self.progressBar hide];
            break;
    }
}


- (void)initiateFacebookShare {
    [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"facebook_share" andCallback:^(NSString *url) {
        [self.progressBar hide];
        
        id<FBGraphObject> object =
        [FBGraphObject openGraphObjectForPostWithType:@"branchmetrics:branchster"
                                                title:self.monsterName
                                                image:[[self prepareBranchDict] objectForKey:@"$og_image_url"]
                                                  url:url
                                          description:[[self prepareBranchDict] objectForKey:@"$og_description"]];
        
        // Create an action
        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        
        // Link the object to the action
        [action setObject:object forKey:@"branchster"];
        [action setObject:@"true" forKey:@"fb:explicitly_shared"];
        
        FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
        params.action = action;
        params.actionType = @"branchmetrics:create";
        
        // If the Facebook app is installed and we can present the share dialog
        if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
            // Show the share dialog
            [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                  actionType:@"branchmetrics:create"
                                         previewPropertyName:@"branchster"
                                                     handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                         if (!error) {
                                                             // Success
                                                             [[Branch getInstance] userCompletedAction:@"share_facebook_success"];
                                                         }
                                                     }];
        } else {
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:[self prepareFBDict:url]
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (!error) {
                                                              if (result == FBWebDialogResultDialogCompleted) {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if ([urlParams valueForKey:@"post_id"]) {
                                                                      // User clicked the Share button
                                                                      [[Branch getInstance] userCompletedAction:@"share_facebook_success"];
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
        
    }];

}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
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
