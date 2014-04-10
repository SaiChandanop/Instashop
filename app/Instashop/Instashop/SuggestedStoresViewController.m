//
//  SuggestedStoresViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SuggestedStoresViewController.h"
#import "SuggestedShopView.h"
#import "NavBarTitleView.h"
#import "AppRootViewController.h"
#import "ISConstants.h"
#import "ShopsAPIHandler.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"
#import "FirstTimeUserViewController.h"
#import "InstagramUserObject.h"
#import "ProfileViewController.h"

@interface SuggestedStoresViewController ()

@end

// THERE ARE ALOT OF SYNCHRONIZATION PROBLEMS WITH THE CODE IN THE FILE, EVEN BEFORE I HAD STARTED WORKING ON IT - Susan

#define kLoginTutorialDone 5
#define kButtonPosition 515.0 // Change this number to change the button position.

@implementation SuggestedStoresViewController

@synthesize appRootViewController;
@synthesize brandsViewsArray;
@synthesize bloggersViewsArray;
@synthesize firstTimeUserViewController;
@synthesize closeTutorialButton;
@synthesize isLaunchedFromMenu;
@synthesize followedIDsArray;
@synthesize shopViewsArray;
@synthesize holdBegin;
@synthesize begun;
@synthesize bgImageView;
@synthesize segmentedControl;
@synthesize theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shopViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.brandsViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.bloggersViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)backButtonHit
{
    [self.appRootViewController suggestedShopExitButtonHit:self.navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"1");
    
    [Utils conformViewControllerToMaxSize:self];
    
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SUGGESTED SHOPS"]];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    self.bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:self.bgImageView atIndex:0];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""  style:UIBarButtonItemStyleBordered target:nil  action:nil];
    
    
    if (!self.holdBegin)
    {
        self.begun = YES;
        [ShopsAPIHandler  getSuggestedShopsWithDelegate:self withCategory:@"Brands"];
    }
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
}

-(void)testRefresh
{
    NSLog(@"testRefresh");
}
-(void)segmentedControlValueChanged:(UISegmentedControl *)theControl
{
    [self.theTableView reloadData];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"%@ request did load", self);
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        /*        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
         NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
         [appDelegate.instagram requestWithParams:params delegate:self];
         */
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        
    }
}




-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray withCategory:(NSString *)theCategory
{
    NSLog(@"suggestedShopsDidReturn, theCategory: %@",  theCategory);
    
    if ([theCategory compare:@"Brands"] == NSOrderedSame)
        [ShopsAPIHandler  getSuggestedShopsWithDelegate:self withCategory:@"Bloggers"];
    
    
    float yPoint = 0;
    for (int i = 0; i < [suggestedShopArray count]; i++)
    {
        SuggestedShopView *suggestedShopView = [[[NSBundle mainBundle] loadNibNamed:@"SuggestedShopView" owner:self options:nil] objectAtIndex:0];
        suggestedShopView.parentController = self;
        suggestedShopView.shopViewInstagramID = [suggestedShopArray objectAtIndex:i];
        //suggestedShopView.frame = CGRectMake(0, yPoint, self.view.frame.size.width, suggestedShopView.frame.size.height);
        suggestedShopView.frame = CGRectMake(0, 0, self.view.frame.size.width, suggestedShopView.frame.size.height);
        
        if ([theCategory compare:@"Brands"] == NSOrderedSame)
            [self.brandsViewsArray addObject:suggestedShopView];
        else
            [self.bloggersViewsArray addObject:suggestedShopView];
        
        [self.shopViewsArray addObject:suggestedShopView];
        
    }

    if ([self.shopViewsArray count] > 0)
        [[self.shopViewsArray objectAtIndex:0] makeIGContentRequest];
 
    [self.theTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 182;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int retVal = 0;
    if (self.segmentedControl.selectedSegmentIndex == 0)
        retVal = [self.brandsViewsArray count];
    else
        retVal = [self.bloggersViewsArray count];
    
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSArray *subviewsArray = [cell subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *theSubView = [subviewsArray objectAtIndex:i];
        [theSubView removeFromSuperview];
    }
    
    SuggestedShopView *suggestedShopView = nil;
    
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
         suggestedShopView = [self.brandsViewsArray objectAtIndex:indexPath.row];
    else
        suggestedShopView = [self.bloggersViewsArray objectAtIndex:indexPath.row];
    
    NSLog(@"suggestedShopView: %@", suggestedShopView);
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(50,50,50,50)];
    blueView.backgroundColor = [UIColor blueColor];
    [suggestedShopView addSubview:blueView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(150,50,50,50)];
    redView.backgroundColor = [UIColor redColor];
    [cell addSubview:redView];
    
    
    return cell;
}



-(void) selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView
{
/*    [self.shopViewsArray removeObject:theShopView];
    
    if ([self.shopViewsArray count] > 0)
        [[self.shopViewsArray objectAtIndex:0] makeIGContentRequest];
  */
}

- (void) updateButton {
    
}

-(void)imageReturnedWithURL:(NSString *)url withImage:(UIImage *)theImage
{
    
}

-(void)shopViewButtonHitWithID:(NSString *)instagramID
{
    if (self.isLaunchedFromMenu)
    {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profileViewController.profileInstagramID = instagramID;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}


@end
