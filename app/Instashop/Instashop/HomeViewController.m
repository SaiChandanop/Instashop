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
#import "AppDelegate.h"
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
     
    [InstagramUserObject deleteStoredUserObject];
    [del userDidLogout];
    
    [self.parentController homeButtonHit];
}

-(IBAction)homeButtonHit
{
    [self.parentController homeButtonHit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
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
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
        self.sellerLabel.text = @"Become a seller";
    else
        self.sellerLabel.text = @"Sell a product";
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}


-(IBAction) tempSellerButtonHit
{
    CreateSellerViewController *createSellerViewController = [[CreateSellerViewController alloc] initWithNibName:@"CreateSellerViewController" bundle:nil];
    createSellerViewController.delegate = self;
    
    UINavigationController *createNavigationController = [[UINavigationController alloc] initWithRootViewController:createSellerViewController];
    [self.parentController presentViewController:createNavigationController animated:YES completion:nil];
    
    UIView *bufferView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bufferView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    [createNavigationController.view addSubview:bufferView];
   
}

-(IBAction) sellerButtonHit
{

    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
    {

        CreateSellerViewController *createSellerViewController = [[CreateSellerViewController alloc] initWithNibName:@"CreateSellerViewController" bundle:nil];
        createSellerViewController.delegate = self;
        
        UINavigationController *createNavigationController = [[UINavigationController alloc] initWithRootViewController:createSellerViewController];
        [self.parentController presentViewController:createNavigationController animated:YES completion:nil];
        
        UIView *bufferView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        bufferView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
        [createNavigationController.view addSubview:bufferView];
    }
    else
       [self.parentController createProductButtonHit];
}


-(void)createSellerDone
{
    [self loadStates];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Great"
                                                        message:@"And now you're a seller"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}


-(void)createSellerCancelButtonHit
{
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}




@end
