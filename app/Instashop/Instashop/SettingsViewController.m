//
//  SettingsViewController.m
//  Instashop
//
//  Created by A50 Admin on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NavBarTitleView.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"
#import "SellersAPIHandler.h"
#import "PullAccountHandler.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize theScrollView;
@synthesize parentController;
@synthesize logoutView;
@synthesize peoplePicker;
@synthesize showInfoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.theScrollView.contentSize = CGSizeMake(0, self.logoutView.frame.origin.y + self.logoutView.frame.size.height);
    [self.view addSubview:self.theScrollView];
    
    
    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50, 44)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"Settings"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"!"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
    NSString *username = [InstagramUserObject getStoredUserObject].username;
    NSLog(@"username: %@", username);
    
    BOOL showPullInfo = NO;
    
    /*
    if ([username compare:@"shopsy"] == NSOrderedSame)
        showPullInfo = YES;
    else if ([username compare:@"jrb3000"] == NSOrderedSame)
        showPullInfo = YES;
    else if ([username compare:@"jklobe"] == NSOrderedSame)
        showPullInfo = YES;
    */
    
    
    if (!showPullInfo)
    {
        self.showInfoView.alpha = 0;
        [self.showInfoView removeFromSuperview];
    }
    
}



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendFeedbackButtonHit
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@"hello@shopsy.com"]];
    [controller setSubject:@"Feedback"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController presentViewController:controller animated:YES completion:nil];
    
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"MFMessageComposeViewController: MessageComposeResultCancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"MFMessageComposeViewController: MessageComposeResultSent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"MFMessageComposeViewController: MessageComposeResultFailed");
            break;
            
        default:
            break;
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [peoplePicker.appRootViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    peoplePicker.view.frame = CGRectMake(0,peoplePicker.view.frame.size.height, peoplePicker.view.frame.size.width, peoplePicker.view.frame.size.height);
    [UIView commitAnimations];
    
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"peoplePickerNavigationController, person: %@", person);
    
    return YES;
}


// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"peoplePickerNavigationController, !shouldContinueAfterSelectingPerson: %@", person); // ABPropertyID: %@ identifier: %@", person, property, identifier);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
//    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:^{
        switch (property) {
            case kABRealPropertyType: {
                NSLog(@"kABRealPropertyType"); //phone
                NSString *phoneNumber = nil;
                ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
                for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
                    if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                        CFRelease(multiPhones);
                        phoneNumber = (__bridge NSString *) phoneNumberRef;
                    }
                }
                
                if (phoneNumber != nil)
                {
                    NSLog(@"phoneNumber: %@", phoneNumber);
                    MFMessageComposeViewController *phonePicker = [[MFMessageComposeViewController alloc] init];
                    phonePicker.recipients = [NSArray arrayWithObject:phoneNumber];
                    phonePicker.messageComposeDelegate = self;
                    phonePicker.body = @"Join Shopsy, the place to shop for products discovered on Instagram. shopsy.com/download";
                    [delegate.appRootViewController presentViewController:phonePicker animated:YES completion:nil];
                }
                
                break;
            }
            case kABDateTimePropertyType:
                NSLog(@"kABDateTimePropertyType"); //email
                
                ABMultiValueRef emailMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
                NSArray *emailAddresses = (NSArray *)CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(emailMultiValue));
                NSLog(@"emailAddresses: %@", emailAddresses);
                if (emailAddresses != nil)
                {
                    NSLog(@"present!!!");
                    MFMailComposeViewController* mailComposerController = [[MFMailComposeViewController alloc] init];
                    mailComposerController.mailComposeDelegate = self;
                    [mailComposerController setToRecipients:[NSArray arrayWithArray:emailAddresses]];
                    [mailComposerController setSubject:@"Download Shopsy"];
                    [mailComposerController setMessageBody:@"I'm using Shopsy to shop for products discovered on Instagram and you should too! http://shopsy.com/download" isHTML:YES];
                    [delegate.appRootViewController presentViewController:mailComposerController animated:YES completion:nil];
                }
                break;
                
        }
//    }];
    return NO;
}

-(IBAction) faqButtonHit
{
    [self.parentController webViewButtonHit:@"http://www.shopsy.com/faq" titleName:@"FAQ"];
}


- (IBAction)inviteButtonHit
{
    NSLog(@"inviteButtonHit");
    
    self.peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    self.peoplePicker.peoplePickerDelegate = self;
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.appRootViewController presentViewController:picker animated:YES completion:nil];
    
    self.peoplePicker.view.frame = CGRectMake(0,self.peoplePicker.view.frame.size.height, self.peoplePicker.view.frame.size.width, self.peoplePicker.view.frame.size.height);
    [delegate.appRootViewController.view addSubview:self.peoplePicker.view];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    self.peoplePicker.view.frame = CGRectMake(0, 0, self.peoplePicker.view.frame.size.width, self.peoplePicker.view.frame.size.height);
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)logOutButtonHit
{
    [self backButtonHit];
    
    NSLog(@"!!updateSellerPushIDWithPushID updateSellerPushIDWithPushID !!");
    [SellersAPIHandler updateSellerPushIDWithPushID:@"" withInstagramID:[InstagramUserObject getStoredUserObject].userID];
    
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.instagram logout];
    
    [del userDidLogout];
    
    [InstagramUserObject deleteStoredUserObject];
    
    [self.parentController homeButtonHit];
}

- (IBAction) reportBugButtonHit {
 
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@"support@shopsy.com"]];
    [controller setSubject:@"Support"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController presentViewController:controller animated:YES completion:nil];

}



-(IBAction)privatePolicyButtonHit
{
    [self.parentController webViewButtonHit:@"http://shopsy.com/privacy" titleName:@"PRIVACY"];
    NSLog(@"privatePolicyButtonHit");
}
- (IBAction) termsOfServiceButtonHit {
    
    [self.parentController webViewButtonHit:@"http://shopsy.com/terms" titleName:@"TERMS"];
    NSLog(@"Yes, the terms of Service Button was hit");
}


-(IBAction) pullInfoButtonHit
{
    [[PullAccountHandler alloc] pullAccount];
}
- (void) backButtonHit {
    NSLog(@"!! back");
    [self.parentController settingsExitButtonHit];
}

@end
