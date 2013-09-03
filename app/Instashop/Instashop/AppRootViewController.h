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
#import "DiscoverViewController.h"



@interface AppRootViewController : UIViewController
{
    UINavigationController *feedNavigationController;
    FeedViewController *feedViewController;
    HomeViewController *homeViewController;
    DiscoverViewController *discoverViewController;
    
    BOOL areViewsTransitioning;
    
    UIButton *feedCoverButton;
}



+(AppRootViewController *)sharedRootViewController;

-(void)homeButtonHit;
-(void)notificationsButtonHit;
-(void)discoverButtonHit;


-(void) createSellerButtonHit;
-(void) createSellerShouldExit:(UINavigationController *)theNavigationController;

-(void)createProductButtonHit;
-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController;


-(void) profileExitButtonHit:(UINavigationController *)navigationController;


-(void) suggestedShopButtonHit;
-(void) suggestedShopExitButtonHit:(UINavigationController *)navigationController;

-(void) searchButtonHit;
-(void) searchExitButtonHit:(UINavigationController *)navigationController;


@property (strong, nonatomic) UINavigationController *feedNavigationController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) DiscoverViewController *discoverViewController;

@property (strong, nonatomic) UIButton *feedCoverButton;

@property (nonatomic, assign) BOOL areViewsTransitioning;

@end
