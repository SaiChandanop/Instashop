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
#import "NotificationsObject.h"
#import "SettingsViewController.h"
#import "WebViewController.h"
#import "SuggestedStoresViewController.h"
@class SearchViewController;

@interface AppRootViewController : UIViewController
{
    UINavigationController *feedNavigationController;
    FeedViewController *feedViewController;
    HomeViewController *homeViewController;
    SearchViewController *theSearchViewController;
    UINavigationController *searchNavigationController;
    NotificationsViewController *notificationsViewController;
    SettingsViewController *settingsViewController;
    UINavigationController *productCreateNavigationController;
    SuggestedStoresViewController *suggestedStoresViewController;
    
    BOOL areViewsTransitioning;
    UIButton *feedCoverButton;
    WebViewController *webView;
    UINavigationController *webViewNavigationController;
    
    UINavigationController *settingsNavigationController;
}



+(AppRootViewController *)sharedRootViewController;
-(void)settingsExitButtonHit;
-(void) homeButtonHit;
-(void) notificationsButtonHit;
-(void) discoverButtonHit;
-(void) createProductButtonHit;
-(void) firstTimeTutorialExit;
-(void) productDidCreateWithNavigationController:(UINavigationController *)theNavigationController;
-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController;
-(void) profileExitButtonHit:(UINavigationController *)navigationController;
-(void) popupViewControllerShouldExit:(UINavigationController *)theNavigationController;
-(void) runTutorialIfAppropriate;
-(void) suggestedShopButtonHit;
-(void) suggestedShopExitButtonHit:(UINavigationController *)navigationController;
-(void) searchButtonHit:(NSString *)searchTerm;
-(void) searchExitButtonHit:(UINavigationController *)navigationController;
-(void) settingsButtonHit;
-(void) settingsBackButtonHit:(UINavigationController *) navigationController;
-(void) webViewButtonHit: (NSString *) websiteName titleName: (NSString *) title;
-(void) webViewExitButtonHit:(UINavigationController *)navigationController;
-(void) notificationSelectedWithProfile:(NSString *)profileInstagramID;
-(void) notificationSelectedWithObject:(NotificationsObject *)notificationsObject;


- (IBAction) profileButtonHit;
@property (strong, nonatomic) UINavigationController *feedNavigationController;
@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) SearchViewController *theSearchViewController;
@property (strong, nonatomic) UINavigationController *searchNavigationController;
@property (strong, nonatomic) FirstTimeUserViewController *firstTimeUserViewController;
@property (strong, nonatomic) NotificationsViewController *notificationsViewController;
@property (strong, nonatomic) SettingsViewController *settingsViewController;
@property (strong, nonatomic) SuggestedStoresViewController *suggestedStoresViewController;
@property (strong, nonatomic) WebViewController *webView;
@property (strong, nonatomic) UINavigationController *webViewNavigationController;
@property (strong, nonatomic) UINavigationController *productCreateNavigationController;
@property (strong, nonatomic) UINavigationController *settingsNavigationController;

@property (nonatomic, assign) BOOL areViewsTransitioning;
@property (strong, nonatomic) UIButton *feedCoverButton;

@property (nonatomic, assign) BOOL firstRun;

@end
