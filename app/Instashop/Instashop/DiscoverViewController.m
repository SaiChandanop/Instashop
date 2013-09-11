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
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"DISCOVER"]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    
    self.discoverTableViewController = [[DiscoverTableViewController alloc] initWithNibName:@"DiscoverTableViewController" bundle:nil];
    self.discoverTableViewController.parentController = self;
    [self.view addSubview:self.discoverTableViewController.tableView];
    
    
    [SellersAPIHandler makeGetAllSellersRequestWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)sellersRequestFinishedWithResponseObject:(NSArray *)responseArray
{
//    NSLog(@"sellersRequestFinishedWithResponseObject: %@", responseArray);
    self.discoverTableViewController.sellersObjectsArray = [[NSArray alloc] initWithArray:responseArray];
    [self.discoverTableViewController.tableView reloadData];
}

-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    NSLog(@"%@ theSelectionObject: %@", self, theSelectionObject);
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = [theSelectionObject objectForKey:@"instagram_id"];
    [self.navigationController pushViewController:profileViewController animated:YES];
}



-(void)backButtonHit
{
    [self.parentController discoverBackButtonHit:self.navigationController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
