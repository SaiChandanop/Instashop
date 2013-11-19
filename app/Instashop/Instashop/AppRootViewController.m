//
//  AppRootViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AppRootViewController.h"
#import "ProductCreateViewController.h"
#import "STPCard.h"
#import "StripeAuthenticationHandler.h"
#import "AttributesManager.h"
#import "ISConstants.h"
#import "CreateSellerViewController.h"
#import "ProfileViewController.h"
#import "InstagramUserObject.h"
#import "SuggestedStoresViewController.h"
#import "SearchViewController.h"
#import "NotificationsViewController.h"
#import "DiscoverViewController.h"
#import "SearchViewController.h"
#import "FirstTimeUserViewController.h"
#import "AmberAPIHandler.h"
#import "WebViewController.h"
#import "SettingsViewController.h"

@implementation AppRootViewController

static AppRootViewController *theSharedRootViewController;

@synthesize feedNavigationController, feedViewController, homeViewController;
@synthesize firstTimeUserViewController;
@synthesize areViewsTransitioning;
@synthesize feedCoverButton;
@synthesize theSearchViewController;
@synthesize firstRun;
@synthesize notificationsViewController;
@synthesize notificationsNavigationViewController;

float transitionTime = .456;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    theSharedRootViewController = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (theSharedRootViewController) {

        self.view.backgroundColor = [ISConstants getISGreenColor];
    }
    return theSharedRootViewController;
}

+ (AppRootViewController *)sharedRootViewController
{
    //    if (theSharedRootViewController == nil)
    //        theSharedRootViewController
    return theSharedRootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.notificationsViewController = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    
    
    [AttributesManager getSharedAttributesManager];
    
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeViewController.parentController = self;
    self.homeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.homeViewController.view];
   
    self.feedViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    self.feedViewController.parentController = self;
    self.feedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.feedViewController];
    self.feedNavigationController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    self.feedNavigationController.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.feedNavigationController.view];
    
	// Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
        
    
}

- (void) runTutorial {
    
    self.firstTimeUserViewController = [[FirstTimeUserViewController alloc] init];
    self.firstTimeUserViewController.parentViewController = self;
    self.firstTimeUserViewController.view.frame = CGRectMake(0, 0.0, self.firstTimeUserViewController.view.frame.size.width, self.firstTimeUserViewController.view.frame.size.height);
    [self.view addSubview:self.firstTimeUserViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.firstTimeUserViewController.view.frame = CGRectMake(0, 0, self.firstTimeUserViewController.view.frame.size.width, self.firstTimeUserViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}

-(void)ceaseTransition
{
    self.areViewsTransitioning = NO;
}

-(void)feedCoverButtonHit:(UIButton *)sender
{
    [self homeButtonHit];
}
-(void)homeButtonHit
{
    if (!self.areViewsTransitioning)
    {
        
        float offset = 55.0;
        
        float offsetPosition = self.view.frame.size.width - offset;
        self.areViewsTransitioning = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        
        if (self.feedNavigationController.view.frame.origin.x == 0)
        {
            self.feedNavigationController.view.frame = CGRectMake(self.feedNavigationController.view.frame.origin.x + offsetPosition, self.feedNavigationController.view.frame.origin.y, self.feedNavigationController.view.frame.size.width, self.feedNavigationController.view.frame.size.height);
//            self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x + offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
            
            self.feedCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.feedCoverButton.backgroundColor = [UIColor clearColor];
            self.feedCoverButton.frame = CGRectMake(0,0, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
            [self.feedCoverButton addTarget:self action:@selector(feedCoverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedNavigationController.view addSubview:self.feedCoverButton];
            
        }
        else
        {
            self.feedNavigationController.view.frame = CGRectMake(self.feedNavigationController.view.frame.origin.x - offsetPosition, self.feedNavigationController.view.frame.origin.y, self.feedNavigationController.view.frame.size.width, self.feedNavigationController.view.frame.size.height);
            [self.feedCoverButton removeFromSuperview];
//            self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x - offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
        }
        [UIView commitAnimations];
        
    }        
}

-(void)notificationsButtonHit
{    
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        [self.notificationsViewController loadNotifications];
        
        if (self.notificationsNavigationViewController == nil)
        {
            self.notificationsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:self.notificationsViewController];
            self.notificationsNavigationViewController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:self.notificationsNavigationViewController.view];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.notificationsNavigationViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
}

-(void)discoverButtonHit
{
    NSLog(@"discoverButtonHit!");
    
    if (!self.areViewsTransitioning)
    {
        DiscoverViewController *discoverViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
        discoverViewController.parentController = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:discoverViewController];
        navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:navigationController .view];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        navigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        
    }
}

-(void)discoverBackButtonHit:(UINavigationController *)navigationController
{
        NSLog(@"discoverBackButtonHit: %@", navigationController);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
}

-(void)createProductButtonHit
{
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        ProductCreateViewController *productCreateViewController = [[ProductCreateViewController alloc] initWithNibName:@"ProductCreateViewController" bundle:nil];
        productCreateViewController.parentController = self;
        
        UINavigationController *productCreateNavigationController = [[UINavigationController alloc] initWithRootViewController:productCreateViewController];
        productCreateNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:productCreateNavigationController .view];
        
        /*
        UIView *bufferView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        bufferView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];

        [self.view addSubview:bufferView];
        */  
         
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        productCreateNavigationController.view.frame = CGRectMake(0, 0, productCreateNavigationController .view.frame.size.width, productCreateNavigationController.view.frame.size.height);
        [UIView commitAnimations];        
    }
}

-(void)createSellerButtonHit
{
    
    CreateSellerViewController *createSellerViewController = [[CreateSellerViewController alloc] initWithNibName:@"CreateSellerViewController" bundle:nil];
    createSellerViewController.delegate = self.homeViewController;
    
    UINavigationController *createNavigationController = [[UINavigationController alloc] initWithRootViewController:createSellerViewController];
    createNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:createNavigationController .view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    createNavigationController.view.frame = CGRectMake(0, 0, createNavigationController .view.frame.size.width, createNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)createSellerShouldExit:(UINavigationController *)theNavigationController
{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) firstTimeTutorialExit {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.firstTimeUserViewController.view.frame = CGRectMake(0.0, screenHeight, self.firstTimeUserViewController.view.frame.size.width, self.firstTimeUserViewController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}


- (IBAction) profileButtonHit
{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = [InstagramUserObject getStoredUserObject].userID;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:navigationController .view];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [profileViewController loadNavigationControlls];
}

- (void) profileExitButtonHit:(UINavigationController *)navigationController
{
    NSLog(@"profileExitButtonHit: %@", navigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


-(void)suggestedShopButtonHit
{
    NSLog(@"root suggestedShopButtonHit");
    SuggestedStoresViewController *suggestedStoresViewController = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    suggestedStoresViewController.isLaunchedFromMenu = YES;
    suggestedStoresViewController.appRootViewController = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:suggestedStoresViewController];
    navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:navigationController .view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)suggestedShopExitButtonHit:(UINavigationController *)navigationController
{
    
    NSLog(@"profileExitButtonHit: %@", navigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)searchButtonHit
{
    if (self.theSearchViewController == nil)
    {
        self.theSearchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        self.theSearchViewController.appRootViewController = self;
    }
    
    UINavigationController *navigationController = self.theSearchViewController.navigationController;
    
    if (navigationController == nil)
    {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self.theSearchViewController];
        navigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:navigationController .view];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, 14, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)searchExitButtonHit:(UINavigationController *)navigationController
{
    NSLog(@"searchExitButtonHit: %@", navigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) settingsButtonHit {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsViewController.parentController = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    [navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController setTitle:@"SETTINGS"];
    navigationController.navigationBar.translucent = NO;
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:navigationController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) settingsBackButtonHit:(UINavigationController *) navigationController {
    
}

- (void) webViewButtonHit: (NSString *) websiteName titleName: (NSString *) title {
    
    // Might want to pretty it up by making background color the same color.  
    WebViewController *webView = [[WebViewController alloc] initWithWebView:websiteName title:title];
    webView.appRootViewController = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webView];
    // Would be better if it's put into the webviewcontroller class but navigation bar isn't allocated by the time this code is run.  Don't know how SuggestedStoresViewController does it yet.
    [navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    navigationController.navigationBar.translucent = NO;
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:navigationController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController.view.frame = CGRectMake(0.0, 00.0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) webViewExitButtonHit:(UINavigationController *)navigationController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    navigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)popupViewControllerShouldExit:(UINavigationController *)theNavigationController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, theNavigationController.view.frame.size.height, self.view.frame.size.width, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}

@end
