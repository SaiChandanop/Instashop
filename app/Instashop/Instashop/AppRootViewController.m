//
//  AppRootViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AppRootViewController.h"

@implementation AppRootViewController

@synthesize feedViewController, homeViewController, discoverViewController, notificationsViewController, profileViewController;

@synthesize areViewsTransitioning;
float transitionTime = .456;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
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
    [self.view addSubview:self.notificationsViewController.view];

    
    
	// Do any additional setup after loading the view.
}


-(void)ceaseTransition
{
    self.areViewsTransitioning = NO;
    NSLog(@"notificationsViewController: %@", self.notificationsViewController.view);
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


@end
