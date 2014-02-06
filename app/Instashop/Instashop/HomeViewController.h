//
//  HomeViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsFinishedProtocol.h"

@class AppRootViewController;
@interface HomeViewController : UIViewController  <NotificationsFinishedProtocol>
{
    AppRootViewController *parentController;
    UIScrollView *theScrollView;
    UILabel *sellerLabel;
    
    UIView *termsView;
    
    UIView *topBarView;
    
    UILabel *notificationsCountLabel;
}

-(void)makeGetNotificationsCountCall;

-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController;
-(void)createSellerDone:(UINavigationController *)theNavigationController;
-(void)loadStates;
-(IBAction)homeButtonHit;
-(IBAction)profileButtonHit;
-(IBAction)suggestedShopButtonHit;
-(IBAction)notificationsButtonHit;
-(IBAction)discoverButtonHit;
- (IBAction) privatePolicyButtonHit;
- (IBAction) termsOfServiceButtonHit;
- (IBAction) settingsButtonHit;

@property (nonatomic, strong) AppRootViewController *parentController;

@property (nonatomic, strong) IBOutlet UIScrollView *theScrollView;

@property (nonatomic, strong) IBOutlet UILabel *sellerLabel;

@property (nonatomic, strong) IBOutlet UIButton *postProductButton;

@property (nonatomic, strong) IBOutlet UIView *termsView;

@property (nonatomic, strong) IBOutlet UIView *logoutView;

@property (nonatomic, strong) IBOutlet UIView *topBarView;

@property (nonatomic, strong) IBOutlet UILabel *notificationsCountLabel;
@end
