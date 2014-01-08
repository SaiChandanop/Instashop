//
//  SettingsViewController.h
//  Instashop
//
//  Created by A50 Admin on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>

@class AppRootViewController;

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

{
    AppRootViewController *parentController;
    UIScrollView *theScrollView;
    UILabel *sellerLabel;
    
    UIView *termsView;
    
}

-(IBAction) inviteButtonHit;
-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController;
-(void)createSellerDone:(UINavigationController *)theNavigationController;
-(void)loadStates;
-(IBAction) homeButtonHit;
-(IBAction) profileButtonHit;
-(IBAction) logOutButtonHit;
-(IBAction) suggestedShopButtonHit;
-(IBAction) notificationsButtonHit;
-(IBAction) discoverButtonHit;
-(IBAction) privatePolicyButtonHit;
-(IBAction) faqButtonHit;
-(IBAction) termsOfServiceButtonHit;
-(IBAction) settingsButtonHit;
-(IBAction) sendFeedbackButtonHit;
-(IBAction) reportBugButtonHit;

@property (nonatomic, strong) AppRootViewController *parentController;
@property (nonatomic, strong) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, strong) IBOutlet UIButton *logOutButton;
@property (nonatomic, strong) IBOutlet UILabel *sellerLabel;
@property (nonatomic, strong) IBOutlet UIView *termsView;
@property (nonatomic, strong) IBOutlet UIView *logoutView;
@property (nonatomic, strong) IBOutlet UIView *topBarView;

@end

