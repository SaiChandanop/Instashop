//
//  SuggestedStoresViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SuggestedStoresViewController.h"
#import "SuggestedShopView.h"
#import "NavBarTitleView.h"
#import "AppRootViewController.h"
#import "ISConstants.h"
#import "ShopsAPIHandler.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"
#import "FirstTimeUserViewController.h"
#import "InstagramUserObject.h"
#import "ProfileViewController.h"

@interface SuggestedStoresViewController ()

@end

// THERE ARE ALOT OF SYNCHRONIZATION PROBLEMS WITH THE CODE IN THE FILE, EVEN BEFORE I HAD STARTED WORKING ON IT - Susan

#define kLoginTutorialDone 5
#define kButtonPosition 515.0 // Change this number to change the button position.

@implementation SuggestedStoresViewController

@synthesize appRootViewController;
@synthesize brandsScrollView;
@synthesize bloggersScrollView;
@synthesize firstTimeUserViewController;
@synthesize closeTutorialButton;
@synthesize isLaunchedFromMenu;
@synthesize followedIDsArray;
@synthesize shopViewsArray;
@synthesize holdBegin;
@synthesize begun;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shopViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.brandsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.tempScrollView.frame.origin.x, self.tempScrollView.frame.origin.y, self.tempScrollView.frame.size.width, self.tempScrollView.frame.size.height)];
    self.bloggersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.tempScrollView.frame.origin.x, self.tempScrollView.frame.origin.y, self.tempScrollView.frame.size.width, self.tempScrollView.frame.size.height)];
    
    [self.view addSubview:self.brandsScrollView];
    [self.tempScrollView removeFromSuperview];
    
    [Utils conformViewControllerToMaxSize:self];
    
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SUGGESTED SHOPS"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStyleBordered target:nil  action:nil];
    
    
    if (!self.holdBegin)
    {
        self.begun = YES;
        [ShopsAPIHandler  getSuggestedShopsWithDelegate:self withCategory:@"Brands"];
    }
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
}

-(void)segmentedControlValueChanged:(UISegmentedControl *)theControl
{
    int index = theControl.selectedSegmentIndex;
    
    if (index == 0)
    {
        if ([self.brandsScrollView superview] == nil)
            [self.view addSubview:self.brandsScrollView];
        
        if ([self.bloggersScrollView superview] != nil)
            [self.bloggersScrollView removeFromSuperview];
    }
    else
    {
        if ([self.bloggersScrollView superview] == nil)
            [self.view addSubview:self.bloggersScrollView];
            
        if ([self.brandsScrollView superview] != nil)
            [self.brandsScrollView removeFromSuperview];
    }
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"%@ request did load", self);
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        /*        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
         NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
         [appDelegate.instagram requestWithParams:params delegate:self];
         */
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        
    }
}




-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray withCategory:(NSString *)theCategory
{
    NSLog(@"suggestedShopsDidReturn, theCategory: %@",  theCategory);
    
    UIScrollView *theScrollView;
    
    if ([theCategory compare:@"Brands"] == NSOrderedSame)
    {
        theScrollView = self.brandsScrollView;
        
        if ([[self.bloggersScrollView subviews] count] == 0)
        {
            [ShopsAPIHandler  getSuggestedShopsWithDelegate:self withCategory:@"Bloggers"];
        }
    }
    else
        theScrollView = self.bloggersScrollView;
    
    NSArray *subviewsArray = [theScrollView subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        [subview removeFromSuperview];
    }
    
    
    
    float yPoint = 0;
    for (int i = 0; i < [suggestedShopArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.parentController = self;
        suggestedShopView.shopViewInstagramID = [suggestedShopArray objectAtIndex:i];
        suggestedShopView.frame = CGRectMake(0, yPoint, self.view.frame.size.width, suggestedShopView.frame.size.height);
        
        [theScrollView addSubview:suggestedShopView];
        theScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height + 60);
        
        yPoint = suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height;
    
        [self.shopViewsArray addObject:suggestedShopView];
    }
    
    if ([self.shopViewsArray count] > 0)
        [[self.shopViewsArray objectAtIndex:0] makeIGContentRequest];
    
}



-(void) selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView
{
    [self.shopViewsArray removeObject:theShopView];
    
    if ([self.shopViewsArray count] > 0)
        [[self.shopViewsArray objectAtIndex:0] makeIGContentRequest];
    
}

- (void) updateButton {
    
}

-(void)imageReturnedWithURL:(NSString *)url withImage:(UIImage *)theImage
{
    
}

-(void)shopViewButtonHitWithID:(NSString *)instagramID
{
    if (self.isLaunchedFromMenu)
    {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profileViewController.profileInstagramID = instagramID;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}


@end
