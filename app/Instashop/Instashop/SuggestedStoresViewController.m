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

#define kLoginTutorialDone 3
#define kButtonPosition 515.0 // Change this number to change the button position.

@implementation SuggestedStoresViewController

@synthesize appRootViewController;
@synthesize contentScrollView;
@synthesize selectedShopsIDSArray;
@synthesize followersArray;
@synthesize firstTimeUserViewController;
@synthesize initiated;
@synthesize closeTutorialButton;
@synthesize likedArrayCount;
@synthesize isLaunchedFromMenu;
@synthesize loadedCount;


// So in order to have only followed users on the list, it would mean that when it's loaded, it updates differently from when these are followed thereafter.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.likedArrayCount = 0;
        self.selectedShopsIDSArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.containerViewsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
    //    NSLog(@"this is params: %@", params);
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    [self performSelectorOnMainThread:@selector(getSuggestedShops) withObject:self.followersArray waitUntilDone:YES];
    
    [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SUGGESTED SHOPS"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
}
    
- (void) getSuggestedShops {
    [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
}
 
-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
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
        //        suggestedShopView.titleLabel.text = suggestedShopView.shopViewInstagramID;
        suggestedShopView.frame = CGRectMake(0, i * suggestedShopView.frame.size.height, self.view.frame.size.width, suggestedShopView.frame.size.height);
//        [self.contentScrollView addSubview:suggestedShopView];
        
        self.contentScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height + 60);
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.selectedShopsIDSArray objectAtIndex:i]], @"method", nil];
        
        NSLog(@"params[%d]: %@", i, params);
        [appDelegate.instagram requestWithParams:params delegate:self];;
        
        [self.containerViewsDictionary setObject:suggestedShopView forKey:suggestedShopView.shopViewInstagramID];
        
        suggestedShopView.followButton.alpha = 0;
    }
}

// Response is not coming back...but I don't think this is my responsibility.  Code looks okay.
// Another things is regarding the first time tutorial.  If the user just stops the app without following some many users and then logs in again later, may skip that part of the tutorial.

// The question is how to manage in which order requests come through.

// Only works correctly when lucky enough to get followers list first then the users lists.

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
    }
    else if ([request.url rangeOfString:@"follows"].length > 0)
    {
        NSLog(@"This is the request URL: %@", request.url);
        
        NSArray *dataArray = [result objectForKey:@"data"];
        NSMutableArray *likedIDsArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i =0; i < [dataArray count]; i++)
            [likedIDsArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"id"]];
        
        self.likedArrayCount = likedIDsArray.count;
        NSLog(@"This is array count: %i", likedIDsArray.count);
        
        if (self.initiated == FALSE) {
            self.followersArray = [[NSMutableArray alloc] initWithArray:likedIDsArray];
            [self.followersArray addObject:[InstagramUserObject getStoredUserObject].userID];
            self.initiated = TRUE;
        }
        
        [self updateButton];
        
        for (id key in self.containerViewsDictionary)
        {
            SuggestedShopView *shopView = [self.containerViewsDictionary objectForKey:key];
            shopView.followButton.alpha = 1;
            if ([likedIDsArray containsObject:shopView.shopViewInstagramID])
                shopView.followButton.selected = YES;
            else
                shopView.followButton.selected = NO;
        }
        
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
                
        NSLog(@"response, dataDictionary: %@", dataDictionary);
        NSString *dataInstagramID = [dataDictionary objectForKey:@"id"];
        
        SuggestedShopView *shopView = [self.containerViewsDictionary objectForKey:dataInstagramID];
        
        if (shopView != nil)
            if ([shopView.shopViewInstagramID compare:dataInstagramID] == NSOrderedSame && ![self.followersArray containsObject:shopView.shopViewInstagramID])
            {

                if ([[dataDictionary objectForKey:@"full_name"] length] != 0 && [[dataDictionary objectForKey:@"bio"] length] != 0)
                {
                    
/*                    shopView.frame = CGRectMake(0, [self.selectedShopsIDSArray indexOfObject:shopView.shopViewInstagramID] * shopView.frame.size.height, self.view.frame.size.width, shopView.frame.size.height);
                    [self.contentScrollView addSubview:shopView];
  */
                    
                    shopView.alpha = 1;
                    NSLog(@"show");
                    shopView.bioLabel.text = [dataDictionary objectForKey:@"bio"];
                    shopView.titleLabel.text = [dataDictionary objectForKey:@"full_name"];
                    //shopView.bioLabel.numberOfLines = 0;
                    //shopView.bioLabel.font = [UIFont systemFontOfSize:8];
                    
                    [ImageAPIHandler makeImageRequestWithDelegate:nil withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:shopView.profileImageView];
                    [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:shopView.theBackgroundImageView withInstagramID:shopView.shopViewInstagramID];
                    
                    [shopView bringSubviewToFront:shopView.profileImageView];
                }
            }
        
        
    }
    self.loadedCount++;
    NSLog(@"total: %d, done: %d", [self.selectedShopsIDSArray count],  self.loadedCount);

    float offsetPoint = 0;
    if ([self.selectedShopsIDSArray count] -1 == self.loadedCount)
        for (int i = 0; i < [self.selectedShopsIDSArray count]; i++)
        {
            SuggestedShopView *shopView = [self.containerViewsDictionary objectForKey:[self.selectedShopsIDSArray objectAtIndex:i]];
            if ([shopView.bioLabel.text length] > 0)
            {
                shopView.frame = CGRectMake(0, offsetPoint, self.view.frame.size.width, shopView.frame.size.height);
                offsetPoint = shopView.frame.origin.y + shopView.frame.size.height;
                [self.contentScrollView addSubview:shopView];
            }
                
        }
        
        

//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateProfileView:) userInfo:theID repeats:NO];
    if ([[self.contentScrollView subviews] count] > 0)
    {
        UIView *suggestedShopView = [[self.contentScrollView subviews] objectAtIndex:[[self.contentScrollView subviews] count] -1];
        self.contentScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height + 60);
    }
}

-(void)shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected
{
    NSLog(@"shopFollowButtonHitWithID: %@", instagramID);
    
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (isSelected)
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"unfollow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
    }
    else
    {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"follow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
    }
}

- (void) updateButton {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGFloat pageWidth = self.firstTimeUserViewController.tutorialScrollView.frame.size.width;
    float offset = self.firstTimeUserViewController.tutorialScrollView.contentOffset.x;
    float fractionalPage = offset/pageWidth;
    NSInteger page = lround(fractionalPage);
    // this gets updated only if I follow or unfollow someone.
    // Code could probably be rearranged to be more efficient.
    if ((offset == (screenWidth * 2)) && self.firstTimeUserViewController != NULL) {
        if (self.likedArrayCount == kLoginTutorialDone) {
            self.firstTimeUserViewController.nextButton.enabled = YES;
            [self.firstTimeUserViewController.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
            [self.firstTimeUserViewController.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.firstTimeUserViewController.nextButton addTarget:self.firstTimeUserViewController action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (self.likedArrayCount < kLoginTutorialDone) {
            [self.firstTimeUserViewController.nextButton setTitle:@"Follow 5 Stores" forState:UIControlStateNormal];
            self.firstTimeUserViewController.nextButton.enabled = NO;
            [self.firstTimeUserViewController.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.firstTimeUserViewController.nextButton addTarget:self.firstTimeUserViewController action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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
