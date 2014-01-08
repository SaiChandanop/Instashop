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
@synthesize contentScrollView;
@synthesize selectedShopsIDSArray;
@synthesize firstTimeUserViewController;
@synthesize closeTutorialButton;
@synthesize isLaunchedFromMenu;
@synthesize followedIDsArray;

// So in order to have only followed users on the list, it would mean that when it's loaded, it updates differently from when these are followed thereafter.

// So what needs to happen here basically is that the array needs to be filled first and check that it's filled.
// And then the getSuggestedShops method should be called.


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedShopsIDSArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.containerViewsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

- (void)viewDidLoad
{
    NSLog(@"%@ view did load", self);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"appDelegate: %@", appDelegate);
    NSLog(@"appDelegate.instagram: %@", appDelegate.instagram);
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    NSLog(@"appDelegate.instagram: %@", appDelegate.instagram);
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SUGGESTED SHOPS"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStyleBordered target:nil  action:nil];
    
}



// Response is not coming back...but I don't think this is my responsibility.  Code looks okay.
// Another thing is regarding the first time tutorial.  If the user just stops the app without following some many users and then logs in again later, may skip that part of the tutorial.
// The question is how to manage in which order requests come through.
// Only works correctly when lucky enough to get followers list first then the users lists.

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"%@ request did load", self);
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        /*        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
         NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
         [appDelegate.instagram requestWithParams:params delegate:self];
         */
    }
    else if ([request.url rangeOfString:@"follows"].length > 0)
    {
        NSLog(@"follows returned");
        
        NSArray *dataArray = [result objectForKey:@"data"];
        
        if (self.followedIDsArray != nil)
            [self.followedIDsArray removeAllObjects];
        else
            self.followedIDsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i =0; i < [dataArray count]; i++)
            [self.followedIDsArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"id"]];
        
        NSLog(@"self.followedIDsArray: %@", self.followedIDsArray);
        
        
        [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
        //        [self updateButton];
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        
    }
}




-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray {
    
    [self.containerViewsDictionary removeAllObjects];
    
    [self.selectedShopsIDSArray addObjectsFromArray:suggestedShopArray];
    
    NSLog(@"This is the selectedShopsIDSArray : %@", self.selectedShopsIDSArray);
    
    NSArray *subviewsArray = [self.contentScrollView subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        [subview removeFromSuperview];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (int i = 0; i < [self.selectedShopsIDSArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.parentController = self;
        suggestedShopView.shopViewInstagramID = [self.selectedShopsIDSArray objectAtIndex:i];
        suggestedShopView.frame = CGRectMake(0, 0, self.view.frame.size.width, suggestedShopView.frame.size.height);
        [suggestedShopView makeIGContentRequest];
    }
}

-(void)selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView
{
    BOOL present = YES;
    
    if ([theShopView.shopViewInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
        present = NO;
    
    if (self.isLaunchedFromMenu)
        if ([self.followedIDsArray containsObject:theShopView.shopViewInstagramID])
            present = NO;
    
    if (present)
    {
        
        [self.containerViewsDictionary setObject:theShopView forKey:theShopView.shopViewInstagramID];
        
        NSArray *shopViewsArray = [self.contentScrollView subviews];
        
        float yPoint = 0;
        for (int i = 0; i < [shopViewsArray count]; i++)
        {
            UIView *shopView = [shopViewsArray objectAtIndex:i];
            yPoint = shopView.frame.origin.y + shopView.frame.size.height;
            
        }
        
        theShopView.frame = CGRectMake(0, yPoint, theShopView.frame.size.width, theShopView.frame.size.height);
        [self.contentScrollView addSubview:theShopView];
        
        self.contentScrollView.contentSize = CGSizeMake(0, theShopView.frame.origin.y +theShopView.frame.size.height + 60);
    }
    
}

// Need to find which method uploads the views and where to start filtering.  



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
