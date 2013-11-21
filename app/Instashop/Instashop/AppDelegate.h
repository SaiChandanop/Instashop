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

#define INSTASHOP_INSTAGRAM_ID @"280421250"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    Instagram *instagram;
    
    AuthenticationViewController *authenticationViewController;
    AppRootViewController *appRootViewController;
    
    NSString *pushDeviceTokenString;

    UIImageView *socialCoverImageView;
}

- (void) tutorialShown;
-(void)userDidLogin;
-(void)userDidLogout;
-(void)makeSafariCallWithURL:(NSURL *)theURL;


- (void)loadShareCoverViewWithImage:(UIImage *)theImage;


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Instagram *instagram;

@property (strong, nonatomic) AuthenticationViewController *authenticationViewController;
@property (strong, nonatomic) AppRootViewController *appRootViewController;

@property (strong, nonatomic) NSString *pushDeviceTokenString;

@property (strong, nonatomic) UIImageView *socialCoverImageView;


@end
