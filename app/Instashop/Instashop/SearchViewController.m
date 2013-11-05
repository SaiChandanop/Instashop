//
//  SearchViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchAPIHandler.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "AppRootViewController.h"
#import "PurchasingViewController.h"
#import "ProfileViewController.h"
#import "AttributesManager.h"
#import "CategoriesViewController.h"

@interface SearchViewController ()


@end

@implementation SearchViewController

@synthesize appRootViewController;

@synthesize productSearchViewController;
@synthesize shopSearchViewController;
@synthesize shopsButton;
@synthesize productsButton;
@synthesize nibHighlightView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SEARCH"]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.theHighlightView = [[UIView alloc] initWithFrame:self.nibHighlightView.frame];
    self.theHighlightView.backgroundColor = [ISConstants getISGreenColor];
    [self.view addSubview:self.theHighlightView];
    
    [self.nibHighlightView removeFromSuperview];
    
    
    self.productSearchViewController = [[SearchSiloViewController alloc] initWithNibName:@"SearchSiloViewController" bundle:nil];
    self.productSearchViewController.parentController = self;
    self.productSearchViewController.searchType = CATEGORIES_TYPE_PRODUCT;
    self.productSearchViewController.view.frame = CGRectMake(0, self.theHighlightView.frame.origin.y + self.theHighlightView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.theHighlightView.frame.origin.y + self. self.theHighlightView.frame.size.height));
    [self.view addSubview:self.productSearchViewController.view];

    
    self.shopSearchViewController = [[SearchSiloViewController alloc] initWithNibName:@"SearchSiloViewController" bundle:nil];
    self.shopSearchViewController.parentController = self;
    self.shopSearchViewController.searchType = CATEGORIES_TYPE_SELLER;
    self.shopSearchViewController.view.frame = CGRectMake(0, self.theHighlightView.frame.origin.y + self.theHighlightView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.theHighlightView.frame.origin.y + self. self.theHighlightView.frame.size.height));
    [self.view addSubview:self.shopSearchViewController.view];

    self.shopSearchViewController.view.alpha = 0;
    
    
    self.productsButton.selected = YES;
}

-(void)backButtonHit
{
    [self.productSearchViewController.theSearchBar resignFirstResponder];
    [self.shopSearchViewController.theSearchBar resignFirstResponder];
    [self.appRootViewController searchExitButtonHit:self.navigationController];
}

-(void)moveHighlightToButton:(UIButton *)theButton
{
    NSLog(@"moveHighlightToButton called");
    float transitionTime = .15;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    self.theHighlightView.frame = CGRectMake(theButton.frame.origin.x, self.theHighlightView.frame.origin.y, theButton.frame.size.width, self.theHighlightView.frame.size.height);
    [UIView commitAnimations];

    self.shopsButton.selected = NO;
    self.productsButton.selected = NO;
    
    theButton.selected = YES;
    
    [self.productSearchViewController.theSearchBar resignFirstResponder];
    [self.shopSearchViewController.theSearchBar resignFirstResponder];
}

-(IBAction)shopsButtonHit:(UIButton *)theButton
{
    [self moveHighlightToButton:theButton];

    self.productSearchViewController.view.alpha = 0;
    self.shopSearchViewController.view.alpha = 1;
}

-(IBAction)productsButtonHit:(UIButton *)theButton
{

    [self moveHighlightToButton:theButton];
    
    self.productSearchViewController.view.alpha = 1;
    self.shopSearchViewController.view.alpha = 0;
         
}

-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
    purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
    purchasingViewController.view.frame = CGRectMake(0, 0, purchasingViewController.view.frame.size.width, purchasingViewController.view.frame.size.height);
    [self.navigationController pushViewController:purchasingViewController animated:YES];
    

}

-(void) rowSelectionOccured:(NSDictionary *)theSelectionObject
{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = [theSelectionObject objectForKey:@"instagram_id"];
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    
}


-(int)getCurrentlySelectedTab
{
    int retVal = -1;
    if (self.shopsButton.selected)
        retVal = 0;
    else if (self.productsButton.selected)
        retVal = 1;

    
    return retVal;
}



@end
