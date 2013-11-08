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

@interface SuggestedStoresViewController ()

@end

#define kLoginTutorialDone 3
#define kButtonPosition 515.0 // Change this number to change the button position.

@implementation SuggestedStoresViewController

@synthesize appRootViewController;
@synthesize contentScrollView;
@synthesize selectedShopsIDSArray;
@synthesize firstTimeUserViewController;
@synthesize initiated;
@synthesize closeTutorialButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.selectedShopsIDSArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.containerViewsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [ShopsAPIHandler getSuggestedShopsWithDelegate:self];
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50, 44)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SUGGESTED SHOPS"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
}

-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray
{
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [self.containerViewsDictionary removeAllObjects];
    
    [self.selectedShopsIDSArray addObjectsFromArray:suggestedShopArray];
    
    NSArray *subviewsArray = [self.contentScrollView subviews];
    NSLog(@"This is the subviewArray count: %i", subviewsArray.count);
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        [subview removeFromSuperview];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"This is the selectedShopsIDSArray count: %i", self.selectedShopsIDSArray.count);
    for (int i = 0; i < [self.selectedShopsIDSArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.parentController = self;
        suggestedShopView.shopViewInstagramID = [self.selectedShopsIDSArray objectAtIndex:i];
//        suggestedShopView.titleLabel.text = suggestedShopView.shopViewInstagramID;
        suggestedShopView.frame = CGRectMake(0, i * suggestedShopView.frame.size.height, self.view.frame.size.width, suggestedShopView.frame.size.height);
        [self.contentScrollView addSubview:suggestedShopView];
        
        self.contentScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height + 60);
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.selectedShopsIDSArray objectAtIndex:i]], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];;
        
        [self.containerViewsDictionary setObject:suggestedShopView forKey:suggestedShopView.shopViewInstagramID];
        
        suggestedShopView.followButton.alpha = 0;
    }
    
    if (self.firstTimeUserViewController != NULL) {
    
        self.firstTimeUserViewController.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, kButtonPosition, screenWidth, screenHeight - kButtonPosition)];
        [self.firstTimeUserViewController.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        self.firstTimeUserViewController.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.firstTimeUserViewController.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
        self.firstTimeUserViewController.nextButton.titleLabel.textColor = [UIColor colorWithRed:70.0 green:70.0 blue:70.0 alpha:1.0];
        [self.firstTimeUserViewController.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
        [self.firstTimeUserViewController.nextButton addTarget:self.firstTimeUserViewController action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeTutorialButton];
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];

    }
    else if ([request.url rangeOfString:@"follows"].length > 0)
    {
        NSArray *dataArray = [result objectForKey:@"data"];

        
        NSMutableArray *likedIDsArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i =0; i < [dataArray count]; i++)
            [likedIDsArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"id"]];
        
        if (self.firstTimeUserViewController != NULL && likedIDsArray.count == kLoginTutorialDone) {
            self.firstTimeUserViewController.nextButton.enabled = YES;
        }
        else if (self.firstTimeUserViewController != NULL && likedIDsArray.count < kLoginTutorialDone) {
            self.firstTimeUserViewController.nextButton.enabled = NO;
            [self.firstTimeUserViewController.nextButton setTitle:@"Follow 5 Stores" forState:UIControlStateDisabled];
        }
        
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
        NSString *dataInstagramID = [dataDictionary objectForKey:@"id"];
        
        SuggestedShopView *shopView = [self.containerViewsDictionary objectForKey:dataInstagramID];
        
        if (shopView != nil)
            if ([shopView.shopViewInstagramID compare:dataInstagramID] == NSOrderedSame)
            {
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

-(void)imageReturnedWithURL:(NSString *)url withImage:(UIImage *)theImage
{
    
}

@end
