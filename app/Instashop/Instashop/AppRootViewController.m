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

@implementation AppRootViewController

static AppRootViewController *theSharedRootViewController;

@synthesize feedNavigationController, feedViewController, homeViewController, discoverViewController, notificationsViewController;
@synthesize areViewsTransitioning;
@synthesize feedCoverButton;

float transitionTime = .456;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    theSharedRootViewController = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (theSharedRootViewController) {

        self.view.backgroundColor = [ISConstants getISGreenColor];
    }
    return theSharedRootViewController;
}

+(AppRootViewController *)sharedRootViewController
{
    //    if (theSharedRootViewController == nil)
    //        theSharedRootViewController
    return theSharedRootViewController;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
 
    [AttributesManager getSharedAttributesManager];
    
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeViewController.parentController = self;
    self.homeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.homeViewController.view];
    
    
    self.discoverViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    self.discoverViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.discoverViewController.view];
    
   
    self.feedViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    self.feedViewController.parentController = self;
    self.feedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.feedViewController];
    self.feedNavigationController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    self.feedNavigationController.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.feedNavigationController.view];
    
    /*
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,20)];
    gapView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    [self.feedNavigationController.view addSubview:gapView];
    */
    
    self.notificationsViewController = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    self.notificationsViewController.view.frame = CGRectMake(0, self.view.frame.size.height * -1, self.view.frame.size.width, self.view.frame.size.height);
//    [self.feedViewController.view insertSubview:self.notificationsViewController.view belowSubview:self.feedViewController.headerView];
    
    
    
	// Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
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
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        if (self.notificationsViewController.view.frame.origin.y == 0)
            self.notificationsViewController.view.frame = CGRectMake(self.feedViewController.view.frame.origin.x, -self.feedViewController.view.frame.size.height, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
        else
            self.notificationsViewController.view.frame = CGRectMake(self.feedViewController.view.frame.origin.x, 0, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
}

-(void)discoverButtonHit
{
    NSLog(@"discoverButtonHit!");
    
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.discoverViewController.view.frame =CGRectMake(0,  self.discoverViewController.view.frame.origin.y, self.discoverViewController.view.frame.size.width, self.discoverViewController.view.frame.size.height);
        self.feedViewController.view.frame =CGRectMake(self.feedViewController.view.frame.origin.x  -  self.feedViewController.view.frame.size.width,  self.feedViewController.view.frame.origin.y, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
        
        [UIView commitAnimations];
        
    }
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
    NSLog(@"createSellerShouldExit: %@", theNavigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, theNavigationController.view.frame.size.height);
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



@end
