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
@synthesize shopViewsArray;
@synthesize begun;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedShopsIDSArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.shopViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
/*        if ([InstagramUserObject getStoredUserObject].userID != nil)
        {
            self.begun = YES;
            [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
        }
 */
    }
    return self;
}

-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

- (void)viewDidLoad
{

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

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
    
    

    if (!self.begun)
    {
        self.begun = YES;
        [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
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




-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray {
        
    [self.selectedShopsIDSArray addObjectsFromArray:suggestedShopArray];
    
    NSLog(@"This is the selectedShopsIDSArray : %@", self.selectedShopsIDSArray);
    NSLog(@"self.view: %@", self.view);
    
    NSArray *subviewsArray = [self.contentScrollView subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        [subview removeFromSuperview];
    }
    
    
    float yPoint = 0;
    for (int i = 0; i < [self.selectedShopsIDSArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.parentController = self;
        suggestedShopView.shopViewInstagramID = [self.selectedShopsIDSArray objectAtIndex:i];
        suggestedShopView.frame = CGRectMake(0, yPoint, self.view.frame.size.width, suggestedShopView.frame.size.height);
        [self.contentScrollView addSubview:suggestedShopView];
        
        self.contentScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height + 60);
        
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
