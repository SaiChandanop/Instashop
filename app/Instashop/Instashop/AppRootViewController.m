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


@implementation AppRootViewController

static AppRootViewController *theSharedRootViewController;

@synthesize feedNavigationController, feedViewController, homeViewController, discoverViewController, notificationsViewController, profileViewController;
@synthesize areViewsTransitioning;
@synthesize productCreateNavigationController;

float transitionTime = .456;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    theSharedRootViewController = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (theSharedRootViewController) {
        
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
    [self.view addSubview:self.feedNavigationController.view];
    
    
    
    
    
    self.notificationsViewController = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    self.notificationsViewController.view.frame = CGRectMake(0, self.view.frame.size.height * -1, self.view.frame.size.width, self.view.frame.size.height);
//    [self.feedViewController.view insertSubview:self.notificationsViewController.view belowSubview:self.feedViewController.headerView];
    
    
    UIButton *stripeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stripeButton.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 100, 100, 50);
    [stripeButton addTarget:self action:@selector(stripeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [stripeButton setTitle:@"Stripe" forState:UIControlStateNormal];
//    [self.view addSubview:stripeButton];
    
    
    
	// Do any additional setup after loading the view.
}

-(void)stripeButtonHit
{
    NSString *stripeToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeToken"];
    
    NSLog(@"stripeTokenDictionary: %@", stripeToken);
    if (stripeToken == nil)
    {
        STPCard *stripeCard = [[STPCard alloc] init];
        stripeCard.number = @"4242424242424242";
        stripeCard.expMonth = 05;
        stripeCard.expYear = 15;
        stripeCard.cvc = @"123";
        stripeCard.name = @"alchemy50";
        stripeCard.addressLine1 = @"20 Jay Street #934";
        stripeCard.addressZip = @"11201";
        stripeCard.addressCity = @"Brooklyn";
        stripeCard.addressState = @"NY";
        stripeCard.addressCountry = @"KINGS";
        
        [StripeAuthenticationHandler createTokenWithCard:stripeCard withDelegate:self];
    }
    
    else
        [self doBuy];
}

-(void)doBuy
{
    NSLog(@"do buy");

    NSString *stripeToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeToken"];
    
    [StripeAuthenticationHandler buyItemWithToken:stripeToken withPurchaseAmount:@"400" withDescription:@"first purchase"];
    
}

-(void)ceaseTransition
{
    self.areViewsTransitioning = NO;
}

-(void)feedCoverButtonHit:(UIButton *)sender
{
    [sender removeFromSuperview];
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
            
            UIButton *feedCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
            feedCoverButton.backgroundColor = [UIColor clearColor];
            feedCoverButton.frame = CGRectMake(0,0, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
            [feedCoverButton addTarget:self action:@selector(feedCoverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedNavigationController.view addSubview:feedCoverButton];
            
        }
        else
        {
            self.feedNavigationController.view.frame = CGRectMake(self.feedNavigationController.view.frame.origin.x - offsetPosition, self.feedNavigationController.view.frame.origin.y, self.feedNavigationController.view.frame.size.width, self.feedNavigationController.view.frame.size.height);
//            self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x - offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
        }
        [UIView commitAnimations];
        
    }
    
    
    NSLog(@"homeButtonHit!");
}

-(void)notificationsButtonHit
{
    NSLog(@"notificationsButtonHit!");
    
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
    NSLog(@"createProductButtonHit");
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        ProductCreateViewController *productCreateViewController = [[ProductCreateViewController alloc] initWithNibName:@"ProductCreateViewController" bundle:nil];
        
        self.productCreateNavigationController = [[UINavigationController alloc] initWithRootViewController:productCreateViewController];
        self.productCreateNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.productCreateNavigationController .view];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(productCreateNavigationControllerExitButtonHit)];
        productCreateViewController.navigationItem.leftBarButtonItem = backButtonItem;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.productCreateNavigationController.view.frame = CGRectMake(0, 0, self.productCreateNavigationController .view.frame.size.width, self.productCreateNavigationController .view.frame.size.height);
        [UIView commitAnimations];
        
    }
}

-(void) productCreateNavigationControllerExitButtonHit
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.productCreateNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, self.productCreateNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)exitButtonHitWithViewController:(UIViewController *)exitingViewController
{
    
    NSLog(@"exitButtonHitWithViewController: %@", exitingViewController);
          
/*    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        exitingViewController.view.frame = CGRectMake(0, exitingViewController.view.frame.size.height, exitingViewController.view.frame.size.width, exitingViewController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
  */  
}

@end
