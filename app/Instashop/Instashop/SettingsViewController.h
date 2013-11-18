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

- (IBAction)inviteButtonHit;
-(IBAction) tempSellerButtonHit;
-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController;
-(void)createSellerDone:(UINavigationController *)theNavigationController;
-(void)loadStates;
-(IBAction)homeButtonHit;
-(IBAction)profileButtonHit;
-(IBAction)logOutButtonHit;
-(IBAction)suggestedShopButtonHit;
-(IBAction)notificationsButtonHit;
-(IBAction)discoverButtonHit;
- (IBAction) privatePolicyButtonHit;
- (IBAction) reportBug;
- (IBAction) termsOfServiceButtonHit;
- (IBAction) settingsButtonHit;
- (IBAction)sendFeedbackButtonHit;
@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, retain) IBOutlet UIButton *logOutButton;

@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;

@property (nonatomic, retain) IBOutlet UIView *termsView;

@property (nonatomic, retain) IBOutlet UIView *logoutView;

@property (nonatomic, retain) IBOutlet UIView *topBarView;

@end

