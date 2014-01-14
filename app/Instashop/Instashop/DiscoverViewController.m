//
//  DiscoverViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewController.h"
#import "NavBarTitleView.h"
#import "ISConstants.h"
#import "SellersAPIHandler.h"
#import "AppRootViewController.h"
#import "ProfileViewController.h"
#import "PurchasingViewController.h"
#import "MBProgressHUD.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

@synthesize parentController;
@synthesize discoverTableViewController;

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
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"DISCOVER"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.discoverTableViewController = [[DiscoverTableViewController alloc] initWithNibName:@"DiscoverTableViewController" bundle:nil];
    self.discoverTableViewController.parentController = self;
    [self.view addSubview:self.discoverTableViewController.tableView];

    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    

        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Loading...";
        UIView *theView = [MBProgressHUD HUDForView:self.view];
}




-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    NSLog(@"%@ theSelectionObject: %@", self, theSelectionObject);
    
    PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
    purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
    [self.navigationController pushViewController:purchasingViewController animated:YES];
    
    /*
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = [theSelectionObject objectForKey:@"instagram_id"];
    [self.navigationController pushViewController:profileViewController animated:YES];
     */
}



-(void)backButtonHit
{
//    [self.parentController discoverBackButtonHit:self.navigationController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
