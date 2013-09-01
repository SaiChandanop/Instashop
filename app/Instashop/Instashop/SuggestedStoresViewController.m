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

@interface SuggestedStoresViewController ()

@end

@implementation SuggestedStoresViewController

@synthesize appRootViewController;
@synthesize contentScrollView;
@synthesize selectedShopsIDSArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.selectedShopsIDSArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.containerViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
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
    NSLog(@"backButtonHit, self.approot: %@", self.appRootViewController);
    
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray
{
    NSLog(@"suggestedShopsDidReturn: %@", suggestedShopArray);
    
    [self.containerViewsArray removeAllObjects];
    
    [self.selectedShopsIDSArray addObjectsFromArray:suggestedShopArray];
    
    NSArray *subviewsArray = [self.contentScrollView subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        [subview removeFromSuperview];
    }

    
    for (int i = 0; i < [self.selectedShopsIDSArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.shopViewInstagramID = [self.selectedShopsIDSArray objectAtIndex:i];
        suggestedShopView.titleLabel.text = suggestedShopView.shopViewInstagramID;
        suggestedShopView.frame = CGRectMake(0, i * suggestedShopView.frame.size.height, self.view.frame.size.width, suggestedShopView.frame.size.height);
        [self.contentScrollView addSubview:suggestedShopView];
        
        self.contentScrollView.contentSize = CGSizeMake(0, suggestedShopView.frame.origin.y + suggestedShopView.frame.size.height);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
