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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    Instagram *instagram;
    AuthenticationViewController *authenticationViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) Instagram *instagram;
@property (strong, nonatomic) AuthenticationViewController *authenticationViewController;
@end
