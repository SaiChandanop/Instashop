//
//  FeedViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FeedViewController.h"
#import "AppRootViewController.h"
#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "PurchasingViewController.h"
#import "ISConstants.h"


@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize parentController;
@synthesize feedItemsArray, selectedObject;
@synthesize productSelectTableViewController;
@synthesize theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.feedItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Utils conformViewControllerToMaxSize:self];
    
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuButton.png"]];
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(homeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    

    UIView *discoverCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *discoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnify.png"]];
    discoverImageView.frame = CGRectMake(0,0,44,44);
    [discoverCustomView addSubview:discoverImageView];
    
    UIButton *discoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    discoverButton.frame = CGRectMake(0,0,discoverCustomView.frame.size.width, discoverCustomView.frame.size.height);
    [discoverButton addTarget:self action:@selector(discoverButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [discoverCustomView addSubview:discoverButton];
    
    UIBarButtonItem *discoverBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:discoverCustomView];
    self.navigationItem.rightBarButtonItem = discoverBarButtonItem;


    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarShopsyLogo.png"]];
    self.navigationItem.titleView = theImageView;

    self.productSelectTableViewController.cellDelegate = self;
    self.productSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS;
    [self.productSelectTableViewController refreshContent];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
        
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(homeButtonHit)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipeRight];


    
    
}
-(void)tapGesture
{
    NSLog(@"tapGesture");
}
-(void)swipeLeftOccured
{
    NSLog(@"self.navigationController.view.frame: %@", NSStringFromCGRect(self.navigationController.view.frame));
    if (self.navigationController.view.frame.origin.x > 0)
        [self homeButtonHit];
/*
   */
}

-(IBAction)homeButtonHit
{
    [self.parentController homeButtonHit];
}

-(IBAction)notificationsButtonHit
{
    NSLog(@"notificationsButtonHit");
    [self.parentController notificationsButtonHit];
}

-(IBAction)discoverButtonHit
{
    [self.parentController searchButtonHit];
}





-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    if (self.navigationController.view.frame.origin.x == 0)
    {
        self.selectedObject = theSelectionObject;

        PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
        purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
        [self.navigationController pushViewController:purchasingViewController animated:YES];
    }
    
}






@end
