//
//  HomeViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "HomeViewController.h"
#import "AppRootViewController.h"
#import "UserAPIHandler.h"
#import "PurchasingAddressViewController.h"
#import "SellersAPIHandler.h"
#import "CreateSellerViewController.h"
#import "GroupDiskManager.h"
#import "InstagramUserObject.h"
#import "InstashopWebView.h"
#import "AppDelegate.h"
#import "ISConstants.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parentController;
@synthesize theScrollView;

@synthesize termsView;
@synthesize logoutView;
@synthesize topBarView;
@synthesize sellerLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)logOutButtonHit
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.instagram logout];
    
    [del userDidLogout];

    [InstagramUserObject deleteStoredUserObject];
    
    [self.parentController homeButtonHit];
}

-(IBAction)homeButtonHit
{
    [self.parentController homeButtonHit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.topBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.theScrollView.contentSize = CGSizeMake(0, self.logoutView.frame.origin.y + self.logoutView.frame.size.height);
    [self.view insertSubview:self.theScrollView belowSubview:self.topBarView];
    
    /* joel use these for reference
    NSLog(@"scroll view size: %@", NSStringFromCGRect(self.theScrollView.frame));
    NSLog(@"scroll view contentSize: %@", NSStringFromCGSize(self.theScrollView.contentSize));
    */
     
    [self loadStates];
}


-(void)loadStates
{
/*    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
        self.sellerLabel.text = @"Become a Seller";
    else
     self.sellerLabel.text = @"Post Product +";
 */
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}


-(IBAction) tempSellerButtonHit
{
    [self.parentController createSellerButtonHit];
}

-(IBAction) sellerButtonHit
{
/*
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
    {
        [self.parentController createSellerButtonHit];
    }
    else
  */
    [self.parentController createProductButtonHit];
}


-(void)createSellerDone:(UINavigationController *)theNavigationController
{
    [self loadStates];
        
    [self.parentController createSellerShouldExit:theNavigationController];
        
}


-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController
{
    [self.parentController createSellerShouldExit:theNavigationController];
}

- (IBAction) privatePolicyButtonHit {
    
    [self.parentController webViewButtonHit:@"http://instashop.com/privacy" titleName:@"PRIVACY"];
    NSLog(@"Yes, the private policy Button was hit");
}

-(IBAction)profileButtonHit
{
    [self.parentController profileButtonHit];
}


-(IBAction)suggestedShopButtonHit
{
    NSLog(@"ib action: suggestedShopButtonHit");
    
    [self.parentController suggestedShopButtonHit];
}

- (IBAction) termsOfServiceButtonHit {
    
    [self.parentController webViewButtonHit:@"http://instashop.com/terms" titleName:@"TERMS"];
    NSLog(@"Yes, the terms of Service Button was hit");
}

-(IBAction)notificationsButtonHit
{
    [self.parentController notificationsButtonHit];
    
}

-(IBAction)discoverButtonHit
{
    [self.parentController discoverButtonHit];
    
}

@end
