//
//  AppRootViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedViewController.h"
#import "HomeViewController.h"
#import "NotificationsViewController.h"
#import "DiscoverViewController.h"



@interface AppRootViewController : UIViewController
{
    UINavigationController *feedNavigationController;
    FeedViewController *feedViewController;
    HomeViewController *homeViewController;
    DiscoverViewController *discoverViewController;
    NotificationsViewController *notificationsViewController;
    
    BOOL areViewsTransitioning;
    
}



+(AppRootViewController *)sharedRootViewController;

-(void)homeButtonHit;
-(void)notificationsButtonHit;
-(void)discoverButtonHit;

-(void)createProductButtonHit;


-(void)exitButtonHitWithViewController:(UIViewController *)exitingViewController;
-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController;


@property (strong, nonatomic) UINavigationController *feedNavigationController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) DiscoverViewController *discoverViewController;
@property (strong, nonatomic) NotificationsViewController *notificationsViewController;

@property (nonatomic, assign) BOOL areViewsTransitioning;

@end
