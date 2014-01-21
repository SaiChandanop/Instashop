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
#import "SellersAPIHandler.h"
#import "GroupDiskManager.h"
#import "InstagramUserObject.h"
#import "InstashopWebView.h"
#import "AppDelegate.h"
#import "ISConstants.h"
#import "Utils.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parentController;
@synthesize theScrollView;

@synthesize termsView;
@synthesize logoutView;
@synthesize topBarView;
@synthesize sellerLabel;
@synthesize postProductButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)homeButtonHit
{
    [self.parentController homeButtonHit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Utils conformViewControllerToMaxSize:self];
    
    
    self.topBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.theScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height);
    [self.view insertSubview:self.theScrollView belowSubview:self.topBarView];
    
   
    
    self.logoutView.frame = CGRectMake(self.logoutView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - self.logoutView.frame.size.height, self.logoutView.frame.size.width, self.logoutView.frame.size.height);

    self.theScrollView.contentSize = CGSizeMake(0, self.logoutView.frame.origin.y + self.logoutView.frame.size.height);
     
    [self loadStates];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
}


-(void)loadStates
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}


-(IBAction) sellerButtonHit
{
    [self.parentController createProductButtonHit];
}


-(void)createSellerDone:(UINavigationController *)theNavigationController
{
    [self loadStates];
        
//    [self.parentController createSellerShouldExit:theNavigationController];
        
}


-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController
{
//    [self.parentController createSellerShouldExit:theNavigationController];
}

- (IBAction) privatePolicyButtonHit {
    
    [self.parentController webViewButtonHit:@"http://instashop.com/privacy" titleName:@"PRIVACY"];
}

-(IBAction)profileButtonHit
{
    [self.parentController profileButtonHit];
}

- (IBAction) settingsButtonHit {
    [self.parentController settingsButtonHit];
}

-(IBAction)suggestedShopButtonHit
{
    NSLog(@"ib action: suggestedShopButtonHit");
    
    [self.parentController suggestedShopButtonHit];
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
