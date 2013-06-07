//
//  AppRootViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AppRootViewController.h"
#import "ProductCreateViewController.h"
@implementation AppRootViewController

static AppRootViewController *theSharedRootViewController;

@synthesize feedViewController, homeViewController, discoverViewController, notificationsViewController, profileViewController;
@synthesize areViewsTransitioning;
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
    self.homeViewController.view.frame = CGRectMake(self.view.frame.size.width * -1, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.homeViewController.view];
    
    
    self.discoverViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    self.discoverViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.discoverViewController.view];
    
    
    self.feedViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    self.feedViewController.parentController = self;
    [self.view addSubview:self.feedViewController.view];
    
    self.notificationsViewController = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    self.notificationsViewController.view.frame = CGRectMake(0, self.view.frame.size.height * -1, self.view.frame.size.width, self.view.frame.size.height);
    [self.feedViewController.view insertSubview:self.notificationsViewController.view belowSubview:self.feedViewController.headerView];

    
    
	// Do any additional setup after loading the view.
}


-(void)ceaseTransition
{
    self.areViewsTransitioning = NO;
}
-(void)homeButtonHit
{
    if (!self.areViewsTransitioning)
    {
        
        float offsetPosition = self.view.frame.size.width * .9;
        self.areViewsTransitioning = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.feedViewController.view.frame = CGRectMake(self.feedViewController.view.frame.origin.x + offsetPosition, self.feedViewController.view.frame.origin.y, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
        self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x + offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
        
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
        productCreateViewController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:productCreateViewController.view];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        productCreateViewController.view.frame = CGRectMake(0, 0, productCreateViewController.view.frame.size.width, productCreateViewController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
}


-(void)exitButtonHitWithViewController:(UIViewController *)exitingViewController
{
    
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        exitingViewController.view.frame = CGRectMake(0, exitingViewController.view.frame.size.height, exitingViewController.view.frame.size.width, exitingViewController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
}

@end
