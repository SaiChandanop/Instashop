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
#import "ProductAPIHandler.h"
#import "ImageAPIHandler.h"
#import "PurchasingViewController.h"
#import "ISConstants.h"


@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize parentController;
@synthesize feedItemsArray, selectedObject;

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
    [ProductAPIHandler getAllProductsWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 23, 20)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuButton.png"]];
    homeImageView.frame = CGRectMake(0,0,23,20);
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
    discoverImageView.frame = CGRectMake(22,11,22,22);
    [discoverCustomView addSubview:discoverImageView];
    
    UIButton *discoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    discoverButton.frame = CGRectMake(0,0,discoverCustomView.frame.size.width, discoverCustomView.frame.size.height);
    [discoverButton addTarget:self action:@selector(discoverButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [discoverCustomView addSubview:discoverButton];
    
    UIBarButtonItem *discoverBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:discoverCustomView];
    self.navigationItem.rightBarButtonItem = discoverBarButtonItem;

    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;


    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    
    
}

NSComparisonResult dateSort(NSDictionary *s1, NSDictionary *s2, void *context) {
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *string1 = [s1 objectForKey:@"products_date_added"];
    NSDate *date1 = [dateFormatter dateFromString:string1];

    NSString *string2 = [s2 objectForKey:@"products_date_added"];
    NSDate *date2 = [dateFormatter dateFromString:string2];

    int ret = [date2 compare:date1];

    [dateFormatter release];
    
    return ret;
    
}


-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    [self.feedItemsArray removeAllObjects];
    
    NSArray *sorted = [theArray sortedArrayUsingFunction:dateSort context:nil];
    [self.feedItemsArray addObjectsFromArray:sorted];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
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
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Coming Soon!"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.feedItemsArray count] / 3 % 3 == 0)
        return ([self.feedItemsArray count] / 3);
    else
        return ([self.feedItemsArray count] / 3) + 1;
}

- (ImagesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    [cell loadWithIndexPath:indexPath withFeedItemsArray:self.feedItemsArray];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  104;
}


-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    self.selectedObject = theSelectionObject;

    PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
    purchasingViewController.parentController = self;
    purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
    purchasingViewController.view.frame = CGRectMake(0, 0, purchasingViewController.view.frame.size.width, purchasingViewController.view.frame.size.height);
    [self.navigationController pushViewController:purchasingViewController animated:YES];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == YES)
    {
        
        
    }
    
}

-(void)purchasingViewControllerBackButtonHitWithVC:(UIViewController *)vc
{
    
}

-(void)refresh
{
    [ProductAPIHandler getAllProductsWithDelegate:self];
}

@end
