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
#import "FirstViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    Instagram *instagram;
    AuthenticationViewController *authenticationViewController;
    
    FirstViewController *firstViewController;
}

-(void)userDidLogin;
-(void)makeSafariCallWithURL:(NSURL *)theURL;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) Instagram *instagram;
@property (strong, nonatomic) AuthenticationViewController *authenticationViewController;

@property (strong, nonatomic) FirstViewController *firstViewController;
@end
