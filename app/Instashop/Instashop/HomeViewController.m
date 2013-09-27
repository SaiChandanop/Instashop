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
#import "ISConstants.h"
#import "HTWebView.h"



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

    self.topBarView.backgroundColor = [ISConstants getISGreenColor];
    
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
        self.sellerLabel.text = @"Become a Seller";
    else
        self.sellerLabel.text = @"Create New Product";
    
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

    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
    {
        [self.parentController createSellerButtonHit];
    }
    else
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

-(IBAction)profileButtonHit
{
    [self.parentController profileButtonHit];
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
    //[self.parentController discoverButtonHit];
    
    // So what I'm understanding about the HTWebView Class is that it takes the text of a web object and then converts it into
    // text to put on the user interface.  It doesn't have any dynamic or changing aspects.  It only delivers text to a UIView.
    // Otherwise, I would be seeing a loadRequest method in either HTWebView.m or in a class that uses HTWebView.m
    // Look at member.json in HomeTalk app.
    // So there needs to be some member object to work with and its aspects will be converted to visible text here.
    HTWebView *exampleWebView = [[HTWebView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
    NSString *url = [NSString stringWithFormat:@" http:\/\/meeganmakes.com<\/a>" ];
    [exampleWebView loadWithContent:url andFontSize:14];
    exampleWebView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:exampleWebView];
}
@end
