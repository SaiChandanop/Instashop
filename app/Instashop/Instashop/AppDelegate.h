//
//  AppDelegate.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"
#import "AuthenticationViewController.h"
#import "AppRootViewController.h"
#import "ProfileViewController.h"
#import "InstagramShareViewController.h"
#define INSTASHOP_INSTAGRAM_ID @"280421250"
#define FLURRY_PRIVATE_KEY @"BRM9HPVXJ62Q45HRX9ZP"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    Instagram *instagram;
    
    AuthenticationViewController *authenticationViewController;
    AppRootViewController *appRootViewController;
    
    NSString *pushDeviceTokenString;

//    InstagramShareView *instagramShareView;
    InstagramShareViewController *instagramShareViewController;
    UIDocumentInteractionController *dicot;
    
    NSMutableArray *masterUsersByIDArray;
    
}

- (void) tutorialShown;
- (void) userDidLogin;
- (void) userDidLogout;
- (void) makeSafariCallWithURL:(NSURL *)theURL;
- (void) loadShareCoverViewProfileViewController:(ProfileViewController *)theProfileViewController;
- (void) socialImageSelected:(UIImage *)theImage;


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Instagram *instagram;

@property (strong, nonatomic) AuthenticationViewController *authenticationViewController;
@property (strong, nonatomic) AppRootViewController *appRootViewController;

@property (strong, nonatomic) NSString *pushDeviceTokenString;

//@property (strong, nonatomic) InstagramShareView *instagramShareView;
@property (strong, nonatomic) InstagramShareViewController *instagramShareViewController;
@property (strong, nonatomic) UIDocumentInteractionController *dicot;

@property (strong, nonatomic) NSMutableArray *masterUsersByIDArray;
@end
