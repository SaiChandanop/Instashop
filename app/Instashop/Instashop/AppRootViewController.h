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
#import "FirstTimeUserViewController.h"
#import "NotificationsViewController.h"
@class SearchViewController;

@interface AppRootViewController : UIViewController
{
    UINavigationController *feedNavigationController;
    FeedViewController *feedViewController;
    HomeViewController *homeViewController;
    SearchViewController *theSearchViewController;
    
    NotificationsViewController *notificationsViewController;
    UINavigationController *notificationsNavigationViewController;
    
    BOOL areViewsTransitioning;
    
    UIButton *feedCoverButton;
}


-(void)popupViewControllerShouldExit:(UINavigationController *)theNavigationController;

+(AppRootViewController *)sharedRootViewController;

-(void)homeButtonHit;
-(void)notificationsButtonHit;
-(void)discoverButtonHit;


-(void) createSellerButtonHit;
-(void) createSellerShouldExit:(UINavigationController *)theNavigationController;

-(void)createProductButtonHit;
- (void) firstTimeTutorialExit;
-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController;


-(void) profileExitButtonHit:(UINavigationController *)navigationController;
- (void) runTutorial;

-(void) suggestedShopButtonHit;
-(void) suggestedShopExitButtonHit:(UINavigationController *)navigationController;

-(void) searchButtonHit;
-(void) searchExitButtonHit:(UINavigationController *)navigationController;
- (void) webViewButtonHit: (NSString *) websiteName titleName: (NSString *) title;
- (void) webViewExitButtonHit:(UINavigationController *)navigationController;


@property (strong, nonatomic) UINavigationController *feedNavigationController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) SearchViewController *theSearchViewController;
@property (strong, nonatomic) FirstTimeUserViewController *firstTimeUserViewController;
@property (strong, nonatomic) NotificationsViewController *notificationsViewController;
@property (strong, nonatomic) UINavigationController *notificationsNavigationViewController;

@property (strong, nonatomic) UIButton *feedCoverButton;

@property (nonatomic, assign) BOOL areViewsTransitioning;
@property (nonatomic, assign) BOOL firstRun;

@end
