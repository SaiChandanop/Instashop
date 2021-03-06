//
//  AppRootViewController.m
//  Instashop
//  Master view controller.  Handles transitions between home and feed, handles all modal presentations and modal like presentations.
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AppRootViewController.h"
#import "ProductCreateViewController.h"
#import "AttributesManager.h"
#import "ISConstants.h"
#import "ProfileViewController.h"
#import "InstagramUserObject.h"
#import "SuggestedStoresViewController.h"
#import "SearchViewController.h"
#import "DiscoverViewController.h"
#import "SearchViewController.h"
#import "FirstTimeUserViewController.h"
#import "AmberAPIHandler.h"
#import "WebViewController.h"
#import "SettingsViewController.h"
#import "DiscoverDataManager.h"
#import "PurchasingViewController.h"
#import "NotificationManager.h"
#import "AuthenticationViewController.h"
#import "AppDelegate.h"
#import "MailchimpAPIHandler.h"
#import "NotificationsAPIHandler.h"
#import "PullAccountHandler.h"
#import "NotificationsTableViewController.h"


@implementation AppRootViewController

static AppRootViewController *theSharedRootViewController;

@synthesize feedNavigationController, feedViewController, homeViewController;
@synthesize firstTimeUserViewController;
@synthesize areViewsTransitioning;
@synthesize feedCoverButton;
@synthesize theSearchViewController;
@synthesize firstRun;
@synthesize notificationsViewController;
@synthesize searchNavigationController;
@synthesize webView;
@synthesize webViewNavigationController;
@synthesize settingsNavigationController;
@synthesize productCreateNavigationController;

float transitionTime = .256;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    theSharedRootViewController = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (theSharedRootViewController) {
        
        self.view.backgroundColor = [ISConstants getISGreenColor];
        
    }
    return theSharedRootViewController;
}

+ (AppRootViewController *)sharedRootViewController
{
    //    if (theSharedRootViewController == nil)
    //        theSharedRootViewController
    return theSharedRootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.notificationsViewController = [[NotificationsTableViewController alloc] initWithNibName:@"NotificationsTableViewController" bundle:nil];
    self.suggestedStoresViewController = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    
    [AttributesManager getSharedAttributesManager];
    
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeViewController.parentController = self;
    self.homeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.homeViewController.view];
    self.homeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    self.feedViewController = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    self.feedViewController.parentController = self;
    self.feedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.feedViewController];
    self.feedNavigationController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    self.feedNavigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG.png"]];
    [self.view addSubview:self.feedNavigationController.view];
    self.feedNavigationController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    
	// Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
    
//    [DiscoverDataManager getSharedDiscoverDataManager];
    
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    
    //    [self runTutorial];

    [self runTutorialIfAppropriate];
    
}

- (void) runTutorialIfAppropriate {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_COMPLETE] == nil)
    {
        if (self.firstTimeUserViewController == nil)
        {
        self.firstTimeUserViewController = [[FirstTimeUserViewController alloc] init];
        self.firstTimeUserViewController.parentViewController = self;
        self.firstTimeUserViewController.view.frame = CGRectMake(0, 0.0, self.firstTimeUserViewController.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.firstTimeUserViewController.view];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.firstTimeUserViewController.view.frame = CGRectMake(0, 0, self.firstTimeUserViewController.view.frame.size.width, self.firstTimeUserViewController.view.frame.size.height);
        [UIView commitAnimations];
        }
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}

-(void)ceaseTransition
{
    if (self.theSearchViewController != nil)
    {
        self.theSearchViewController;
        self.theSearchViewController = nil;
    }
    self.areViewsTransitioning = NO;
}

-(void)feedCoverButtonHit:(UIButton *)sender
{
    [self homeButtonHit];
}
-(void)homeButtonHit
{
    if (!self.areViewsTransitioning)
    {
        
        float offset = 55.0;
        
        float offsetPosition = self.view.frame.size.width - offset;
        self.areViewsTransitioning = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        
        if (self.feedNavigationController.view.frame.origin.x == 0)
        {
            self.feedNavigationController.view.frame = CGRectMake(self.feedNavigationController.view.frame.origin.x + offsetPosition, self.feedNavigationController.view.frame.origin.y, self.feedNavigationController.view.frame.size.width, self.feedNavigationController.view.frame.size.height);
            //            self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x + offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
            
            self.feedCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.feedCoverButton.backgroundColor = [UIColor clearColor];
            self.feedCoverButton.frame = CGRectMake(0,0, self.feedViewController.view.frame.size.width, self.feedViewController.view.frame.size.height);
            [self.feedCoverButton addTarget:self action:@selector(feedCoverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedNavigationController.view addSubview:self.feedCoverButton];
            
        }
        else
        {
            self.feedNavigationController.view.frame = CGRectMake(self.feedNavigationController.view.frame.origin.x - offsetPosition, self.feedNavigationController.view.frame.origin.y, self.feedNavigationController.view.frame.size.width, self.feedNavigationController.view.frame.size.height);
            [self.feedCoverButton removeFromSuperview];
            //            self.homeViewController.view.frame =CGRectMake(self.homeViewController.view.frame.origin.x - offsetPosition, self.homeViewController.view.frame.origin.y, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
        }
        [UIView commitAnimations];
        
    }
}

-(void)notificationsButtonHit
{
    if (!self.areViewsTransitioning)
    {
        [self homeButtonHit];
        [self.notificationsViewController loadNotifications];
        [self.feedNavigationController pushViewController:notificationsViewController animated:YES];
        
        [NotificationsAPIHandler clearAllNotificationsCountInstagramID:[InstagramUserObject getStoredUserObject].userID withDelegate:self.notificationsViewController];
    }
}

-(void)discoverButtonHit
{
    NSLog(@"discoverButtonHit!");
    
    if (!self.areViewsTransitioning)
    {
        [self homeButtonHit];
        
        DiscoverViewController *discoverViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
        discoverViewController.parentController = self;
        [self.feedNavigationController pushViewController:discoverViewController animated:YES];
    }
}


-(void)createProductButtonHit
{
    if (!self.areViewsTransitioning)
    {
        self.areViewsTransitioning = YES;
        
        ProductCreateViewController *productCreateViewController = [[ProductCreateViewController alloc] initWithNibName:@"ProductCreateViewController" bundle:nil];
        productCreateViewController.parentController = self;
        
        self.productCreateNavigationController = [[UINavigationController alloc] initWithRootViewController:productCreateViewController];
        self.productCreateNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.productCreateNavigationController .view];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:transitionTime];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        self.productCreateNavigationController.view.frame = CGRectMake(0, 0, self.productCreateNavigationController .view.frame.size.width, self.productCreateNavigationController.view.frame.size.height);
        [UIView commitAnimations];
    }
}



- (void) firstTimeTutorialExit {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
     CGSize screenSize = screenBound.size;
     CGFloat screenHeight = screenSize.height;
     
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:transitionTime];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
     self.firstTimeUserViewController.view.frame = CGRectMake(0.0, screenHeight, self.firstTimeUserViewController.view.frame.size.width, self.firstTimeUserViewController.view.frame.size.height);
     [UIView commitAnimations];
    
    NSLog(@"firstTimeTutorialExit!");
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:TUTORIAL_COMPLETE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

-(void)productDidCreateWithNavigationController:(UINavigationController *)theNavigationController
{
    NSLog(@"productDidCreateWithNavigationController, theNavigationController: %@", theNavigationController);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(productDidCreateWithNavigationControllerDidFinish)];
    theNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
    
    
    
}

-(void)productDidCreateWithNavigationControllerDidFinish
{
    if (self.feedNavigationController.view.frame.origin.x == 0)
    {
        [self.feedNavigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self homeButtonHit];
    }
    [self.feedViewController.productSelectTableViewController refreshContent];
}

-(void) productCreateNavigationControllerExitButtonHit:(UINavigationController *)theNavigationController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}


- (IBAction) profileButtonHit
{
    NSLog(@"profileButtonHit");
    [self homeButtonHit];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = [InstagramUserObject getStoredUserObject].userID;
    [self.feedNavigationController pushViewController:profileViewController animated:YES];
    [profileViewController loadNavigationControlls];
    
}


-(void)suggestedShopButtonHit
{
    NSLog(@"root suggestedShopButtonHit");
    
    [self homeButtonHit];
    
    self.suggestedStoresViewController.isLaunchedFromMenu = YES;
    self.suggestedStoresViewController.appRootViewController = self;
    [self.feedNavigationController pushViewController:self.suggestedStoresViewController animated:YES];
    
}

-(void)searchButtonHit
{
    if (self.theSearchViewController == nil)
    {
        self.theSearchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        self.theSearchViewController.appRootViewController = self;
    }
    
    if (self.searchNavigationController == nil)
    {
        self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:self.theSearchViewController];
        self.searchNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.searchNavigationController .view];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.searchNavigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) searchButtonHitWithString:(NSString *)selectedCategory withCategoriesArray:(NSArray *)searchCategoriesArray
{
    NSLog(@"searchButtonHitWithString");
    
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    
    selectedCategory = [selectedCategory stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    int iter = 0;
    BOOL done = NO;
    while (!done && iter < [searchCategoriesArray count])
    {
        NSString *arrayItem = [[searchCategoriesArray objectAtIndex:iter] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [ar addObject:arrayItem];
        if ([arrayItem compare:selectedCategory] == NSOrderedSame)
            done = YES;
        iter++;
    }
    
    
    if (self.theSearchViewController == nil)
    {
        self.theSearchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        self.theSearchViewController.appRootViewController = self;
        self.theSearchViewController.directArray = [[NSArray alloc] initWithArray:ar];
    }
    else
    {
        [self.theSearchViewController.productSearchViewController.freeSearchTextArray removeAllObjects];
        [self.theSearchViewController.productSearchViewController.selectedCategoriesArray removeAllObjects];
        [self.theSearchViewController.productSearchViewController.selectedCategoriesArray addObjectsFromArray:ar];
        [self.theSearchViewController.productSearchViewController runSearch];
        [self.theSearchViewController.productSearchViewController layoutSearchBarContainers];
    }
    
    if (self.searchNavigationController == nil)
    {
        self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:self.theSearchViewController];
        self.searchNavigationController .view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.searchNavigationController .view];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.searchNavigationController .view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
    
    
    
    
    
    
}


-(void)searchDidComplete
{
    [self.theSearchViewController.view removeFromSuperview];
    self.theSearchViewController = nil;
    
    [self.searchNavigationController.view removeFromSuperview];
    self.searchNavigationController = nil;
    
    [self ceaseTransition];
}
-(void)searchExitButtonHit:(UINavigationController *)navigationController
{
    NSLog(@"searchExitButtonHit: %@", navigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(searchDidComplete)];
    self.searchNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) settingsButtonHit {
    
    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    self.settingsViewController.parentController = self;
    
    self.settingsNavigationController= [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
    
    [self.settingsNavigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.settingsNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.settingsNavigationController setTitle:@"SETTINGS"];
    self.settingsNavigationController.navigationBar.translucent = NO;
    self.settingsNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.settingsNavigationController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.settingsNavigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (void) webViewButtonHit: (NSString *) websiteName titleName: (NSString *) title {
    
    // Might want to pretty it up by making background color the same color.
    self.webView = [[WebViewController alloc] initWithWebView:websiteName title:title];
    self.webView.appRootViewController = self;
    
    self.webViewNavigationController = [[UINavigationController alloc] initWithRootViewController:webView];
    // Would be better if it's put into the webviewcontroller class but navigation bar isn't allocated by the time this code is run.  Don't know how SuggestedStoresViewController does it yet.
    [self.webViewNavigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.webViewNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.webViewNavigationController.navigationBar.translucent = NO;
    self.webViewNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.webViewNavigationController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.webViewNavigationController.view.frame = CGRectMake(0.0, 00.0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)settingsExitButtonHit
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.settingsNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
- (void) webViewExitButtonHit:(UINavigationController *)navigationController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.webViewNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)popupViewControllerShouldExit:(UINavigationController *)theNavigationController
{
    NSLog(@"popupViewControllerShouldExit: %@", theNavigationController);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    theNavigationController.view.frame = CGRectMake(0, theNavigationController.view.frame.size.height, self.view.frame.size.width, theNavigationController.view.frame.size.height);
    [UIView commitAnimations];
}


-(void) notificationSelectedWithProfile:(NSString *)profileInstagramID
{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileInstagramID = profileInstagramID;
    [self.feedNavigationController pushViewController:profileViewController animated:YES];
    [profileViewController loadNavigationControlls];
    
}

-(void) notificationSelectedWithObject:(NotificationsObject *)notificationsObject
{
    NSLog(@"notificationsObject.message: %@", notificationsObject.message);
    NSLog(@"notificationsObject.dataDictionary: %@", notificationsObject.dataDictionary);

    
    if ([[notificationsObject.dataDictionary objectForKey:@"type"] integerValue] < 4)
    {
        PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
        purchasingViewController.requestingProductID = [notificationsObject.dataDictionary objectForKey:@"product_id"];
        [self.feedNavigationController pushViewController:purchasingViewController animated:YES];
    }
    else //([[notificationsObject.dataDictionary objectForKey:@"type"] integerValue] == 4)
    {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profileViewController.profileInstagramID = [notificationsObject.dataDictionary objectForKey:@"creator_id"];
        [self.feedNavigationController pushViewController:profileViewController animated:YES];
        [profileViewController loadNavigationControlls];

        
        
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
