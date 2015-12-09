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
#import "Branch.h"
#import "BranchUniversalObject.h"
#import "BranchUniversalObject+MonsterHelpers.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MonsterViewerViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>


@property (strong, nonatomic)BranchUniversalObject *viewingMonster;

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


@property (weak, nonatomic) IBOutlet UIButton *cmdChange;
@property (weak, nonatomic) IBOutlet UIButton *cmdInfo;



@property (weak, nonatomic) IBOutlet UITextView *shareTextView;
@property NSString* shareURL;
@end

@implementation MonsterViewerViewController

static CGFloat MONSTER_HEIGHT = 0.4f;



- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.botLayerOneColor setBackgroundColor:[MonsterPartsFactory colorForIndex:[self.viewingMonster getColorIndex]]];
    [self.botLayerTwoBody setImage:[MonsterPartsFactory imageForBody:[self.viewingMonster getBodyIndex]]];
    [self.botLayerThreeFace setImage:[MonsterPartsFactory imageForFace:[self.viewingMonster getFaceIndex]]];
    
    self.monsterName = [self.viewingMonster getMonsterName];
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

}



-(void) setViewingMonster: (BranchUniversalObject*) monster {
    _viewingMonster = monster;
    
    //and every time it gets set, I need to create a new url
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"monster_sharing";
    linkProperties.channel = @"twitter";

    [self.viewingMonster getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *error) {
        if (!error) {
            self.shareURL = url;
            NSLog(@"new monster url created:  %@", self.shareURL);
            self.shareTextView.text = url;
        }
    }];
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

#pragma mark - Button Actions

- (IBAction)cmdMessageClick:(id)sender {
    // track that the user clicked the share via sms button and pass in the monster meta data
    [[Branch getInstance] userCompletedAction:@"share_sms_click" withState:self.monsterMetadata];
    
    if([MFMessageComposeViewController canSendText]){
        [self.progressBar changeMessageTo:@"preparing message.."];
        [self.progressBar show];
        
        MFMessageComposeViewController *smsViewController = [[MFMessageComposeViewController alloc] init];
        smsViewController.messageComposeDelegate = self;
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'sms' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"sms" andCallback:^(NSString *url, NSError *error) {
            [self.progressBar hide];
            
            // if there was no error, show the SMS View Controller with the Branch deep link
            if (!error) {
                smsViewController.body = [NSString stringWithFormat:@"Check out my Branchster named %@ at %@", self.monsterName, url];
                [self presentViewController:smsViewController animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Message Support" message:@"This device does not support messaging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }

}

- (IBAction)cmdMailClick:(id)sender {
    // track that the user clicked the share via email button and pass in the monster details
    [[Branch getInstance] userCompletedAction:@"share_email_click" withState:self.monsterMetadata];
    
    if ([MFMailComposeViewController canSendMail]) {
        [self.progressBar changeMessageTo:@"preparing mail.."];
        [self.progressBar show];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Check out my Branchster named %@", self.monsterName]];
        NSArray *toRecipients = nil;
        [mailer setToRecipients:toRecipients];
        
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'email' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"email" andCallback:^(NSString *url, NSError *error) {
            [self.progressBar hide];
            
            // if there was no error, show the Email View Controller with the Branch deep link
            if (!error) {
                NSString *emailBody = [NSString stringWithFormat:@"I just created this Branchster named %@ in the Branch Monster Factory.\n\nSee it here:\n%@", self.monsterName, url];
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentViewController:mailer animated:YES completion:nil];
            }
        }];
        
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Mail Support" message:@"Your default mail client is not configured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdTwitterClick:(id)sender {
    // track that user clicked the share on Twitter button and pass in the monster metadata
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
        
        // Create Branch link as soon as the user clicks
        // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
        // Specify the channel to be 'twitter' for tracking on the Branch dashboard
        [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"twitter" andCallback:^(NSString *url, NSError *error) {
            [self.progressBar hide];
            
            // if there was no error, show the Twitter Share View Controller with the Branch deep link
            if (!error) {
                [twitterController setInitialText:[NSString stringWithFormat:@"Check out my Branchster named %@", self.monsterName]];
                [twitterController addURL:[NSURL URLWithString:url]];
                [twitterController setCompletionHandler:completionHandler];
                [self presentViewController:twitterController animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"No Twitter Account" message:@"You do not seem to have Facebook on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert_Dialog show];
        alert_Dialog = nil;
    }
}

- (IBAction)cmdFacebookClick:(id)sender {
    // track that user clicked the share button on facebook and pass in the monster metadata
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

#pragma mark - Facebook

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
    
    // Create Branch link as soon as we know there is a valid Facebook session
    // Pass in the special Branch dictionary of keys/values you want to receive in the AppDelegate on initSession
    // Specify the channel to be 'facebook' for tracking on the Branch dashboard
    [[Branch getInstance] getContentUrlWithParams:[self prepareBranchDict]  andChannel:@"facebook" andCallback:^(NSString *url, NSError *error) {
        [self.progressBar hide];
        
        // If there is no error, do all the fancy foot work to initiate a share on Facebook
        if (!error) {
            id<FBGraphObject> object = [FBGraphObject openGraphObjectForPostWithType:@"branchmetrics:branchster"
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
                                                             // track a successful share event via Facebook
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
                                                                      // Success
                                                                      // track a successful share event via Facebook
                                                                      [[Branch getInstance] userCompletedAction:@"share_facebook_success"];
                                                                  }
                                                              }
                                                          }
                                                      }];
            }
        }
        
    }];

}

#pragma mark - Helper methods

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

#pragma mark - MFMessageComposeViewControllerProtocol

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if (MessageComposeResultSent == result) {
        
        // track successful share event via sms
        [[Branch getInstance] userCompletedAction:@"share_sms_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (MFMailComposeResultSent == result) {
        
        // track successful share event via email
        [[Branch getInstance] userCompletedAction:@"share_email_success"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
