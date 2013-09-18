//
//  ProfileViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"
#import "ImagesTableViewCell.h"
#import "ProductAPIHandler.h"
#import "PurchasingViewController.h"
#import "ISConstants.h"
#import "GroupDiskManager.h"
#import "GKImagePicker.h"
#import "InstagramUserObject.h"
#import "NavBarTitleView.h"
#import "SellersAPIHandler.h"
#import <QuartzCore/QuartzCore.h>



@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileInstagramID;

@synthesize backgroundImageView;
@synthesize addBackgroundImageButton;
@synthesize profileImageView;
@synthesize usernameLabel;
@synthesize sellerButtonsView;
@synthesize buyerButtonsView;
@synthesize sellerProductsButton, sellerInfoButton, sellerReviewsButton;
@synthesize sellerButtonHighlightView;
@synthesize buyerFavoritesButton;
@synthesize buyerButtonHighlightView;
@synthesize infoContainerScrollView;
@synthesize productSelectTableViewController;
@synthesize theTableView;
@synthesize followersButton;
@synthesize followingButton;
@synthesize profileBackgroundPhotoButton;
@synthesize titleViewLabel;
@synthesize isSelfProfile;
@synthesize followButton;
@synthesize requestedInstagramProfileObject;
@synthesize bioContainerImageView;
@synthesize addressLabel;
@synthesize emailLabel;
@synthesize categoryLabel;
@synthesize bioLabel;
@synthesize descriptionLabel;
@synthesize infoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    [super viewDidLoad];
    self.profileBackgroundPhotoButton.alpha = 0;
    // Do any additional setup after loading the view from its nib.
    
    self.sellerButtonHighlightView.backgroundColor = [ISConstants getISGreenColor];
    self.buyerButtonHighlightView.backgroundColor = [ISConstants getISGreenColor];
    
    self.sellerProductsButton.selected = YES;
    self.sellerInfoButton.selected = NO;
    self.sellerReviewsButton.selected = NO;
    
    self.buyerFavoritesButton.selected = YES;
    self.infoButton.selected = NO;
    self.reviewsButton.selected = NO;
    
    
    self.followButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.followButton.layer.shadowOpacity = .75;
    self.followButton.layer.shadowRadius = 2.5;
    self.followButton.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.followButton.layer.cornerRadius = 2;
    
    
    self.followButton.alpha = 0;
    
    
    
}




- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    self.infoContainerScrollView.frame = self.theTableView.frame;
    
    
    
    if (self.isSelfProfile && [InstagramUserObject getStoredUserObject].zencartID == nil)
    {
        
        NSLog(@"show buyer");
        self.buyerButtonsView.frame = self.sellerButtonsView.frame;
        [self.sellerButtonsView removeFromSuperview];
        [self.view addSubview:self.buyerButtonsView];
        
        
        self.productSelectTableViewController.contentRequestParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/liked", @"method", @"-1", @"count", nil];
        self.productSelectTableViewController.cellDelegate = self;
        self.productSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER;
        self.productSelectTableViewController.productRequestorReferenceObject = self.profileInstagramID;
        [self.productSelectTableViewController refreshContent];
        
        
    }
    else
    {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", self.profileInstagramID], @"method", @"-1", @"count", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
        self.productSelectTableViewController.cellDelegate = self;
        self.productSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER;
        self.productSelectTableViewController.productRequestorReferenceObject = self.profileInstagramID;
        [self.productSelectTableViewController refreshContent];
        
    }
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
        self.profileBackgroundPhotoButton.alpha = .5;
    
    
    
    
    
}


-(void)sellerDetailsResopnseDidOccurWithDictionary:(NSDictionary *)responseDictionary
{
    if ([responseDictionary isKindOfClass:[NSDictionary class]])
    {
        NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@", [responseDictionary objectForKey:@"seller_address"], [responseDictionary objectForKey:@"seller_city"], [responseDictionary objectForKey:@"seller_state"]];
        self.addressLabel.text = addressString;
        self.emailLabel.text = [responseDictionary objectForKey:@"seller_email"];
        self.categoryLabel.text = [responseDictionary objectForKey:@"seller_category"];
    }
    
}




-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
    purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
    purchasingViewController.view.frame = CGRectMake(0, 0, purchasingViewController.view.frame.size.width, purchasingViewController.view.frame.size.height);
    [self.navigationController pushViewController:purchasingViewController animated:YES];
    
}

-(void)loadNavigationControlls
{
    
    self.isSelfProfile = YES;
  //  [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self setTitleViewText:[InstagramUserObject getStoredUserObject].username];
    self.usernameLabel.text = [InstagramUserObject getStoredUserObject].fullName;
    
    [self loadTheProfileImageViewWithID:[InstagramUserObject getStoredUserObject].userID];
    

    self.bioLabel.text = [InstagramUserObject getStoredUserObject].bio;
    [self handleBioLayout];

    
    
}

-(void) backButtonHit
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController profileExitButtonHit:self.navigationController];
}



-(void) setTitleViewText:(NSString *)theText
{
    self.titleViewLabel.text = theText;
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:theText]];
}

-(void)handleBioLayout
{
    float descSpacer = self.descriptionLabel.frame.origin.y - self.bioContainerImageView.frame.origin.y - self.bioContainerImageView.frame.size.height;
    self.bioLabel.numberOfLines = 0;
    CGSize bioLabelSize = [self.bioLabel.text sizeWithFont:self.bioLabel.font constrainedToSize:CGSizeMake(self.bioLabel.frame.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.bioLabel.frame = CGRectMake(self.bioLabel.frame.origin.x, self.bioLabel.frame.origin.y, self.bioLabel.frame.size.width, bioLabelSize.height + 1);
    self.bioContainerImageView.frame = CGRectMake(self.bioContainerImageView.frame.origin.x, self.bioContainerImageView.frame.origin.y, self.bioContainerImageView.frame.size.width, self.bioLabel.frame.size.height + 21);
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.bioContainerImageView.frame.origin.y + bioContainerImageView.frame.size.height + descSpacer, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height);
    
    
    self.infoContainerScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightMenuBG.png"]];
    self.infoContainerScrollView.contentSize = CGSizeMake(0, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 4);
   
}


-(void)loadViewsWithRequestedProfileObject:(NSDictionary *)theReqeustedProfileObject
{
    
    self.requestedInstagramProfileObject = [[NSDictionary alloc] initWithDictionary:theReqeustedProfileObject];

    self.usernameLabel.text = [self.requestedInstagramProfileObject objectForKey:@"full_name"];
    [self setTitleViewText:[self.requestedInstagramProfileObject objectForKey:@"username"]];
    
    [self loadTheProfileImageViewWithID:[self.requestedInstagramProfileObject objectForKey:@"id"]];
    
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedInstagramProfileObject objectForKey:@"profile_picture"] withImageView:self.profileImageView];
    
    NSDictionary *countsDictionary = [self.requestedInstagramProfileObject objectForKey:@"counts"];
    [self.followersButton setTitle:[NSString stringWithFormat:@"%d%@", [[countsDictionary objectForKey:@"followed_by"] integerValue], @" Followers"] forState:UIControlStateNormal];
    [self.followingButton setTitle:[NSString stringWithFormat:@"%d%@", [[countsDictionary objectForKey:@"follows"] integerValue], @" Following"] forState:UIControlStateNormal];
    
    
    [SellersAPIHandler getSellerDetailsWithInstagramID:[self.requestedInstagramProfileObject objectForKey:@"id"] withDelegate:self];

    
    self.bioLabel.text = [self.requestedInstagramProfileObject objectForKey:@"bio"];
    [self handleBioLayout];

    
}

-(IBAction)followOnInstagramButtonHit
{
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!self.followButton.selected)
    {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", [self.requestedInstagramProfileObject objectForKey:@"id"]], @"method", @"follow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
        
    }
    else
    {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", [self.requestedInstagramProfileObject objectForKey:@"id"]], @"method", @"unfollow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
        
    }
    
    
    
}
- (void)request:(IGRequest *)request didLoad:(id)result
{
    
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        if ([request.url rangeOfString:@"media"].length > 0)
        {
            
        }
        else if ([request.url rangeOfString:@"follows"].length > 0)
        {
            NSArray *dataArray = [result objectForKey:@"data"];
            
            
            
            
            if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
                self.followButton.alpha = 1;
            
            BOOL doesFollow = NO;
            
            for (int i = 0; i < [dataArray count]; i++)
            {
                NSString *followID = [[dataArray objectAtIndex:i] objectForKey:@"id"];
                
                if ([followID compare:(NSString *)[self.requestedInstagramProfileObject objectForKey:@"id"]] == NSOrderedSame)
                    doesFollow = YES;
            }
            
            if (doesFollow)
                self.followButton.selected = YES;
            else
                self.followButton.selected = NO;
        }
        else if ([request.url rangeOfString:@"relationship"].length > 0)
        {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
            [theAppDelegate.instagram requestWithParams:params delegate:self];
            
        }
        else if ([request.url rangeOfString:@"users"].length > 0)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            [self loadViewsWithRequestedProfileObject:dataDictionary];
            
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
            [theAppDelegate.instagram requestWithParams:params delegate:self];
        }
    }
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request: %@, error: %@", request, error);
}


-(void) animateSellerButton:(UIButton *)receivingButton
{
    float transitionTime = .15;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    self.buyerButtonHighlightView.frame = CGRectMake(receivingButton.frame.origin.x, self.buyerButtonHighlightView.frame.origin.y, receivingButton.frame.size.width, self.buyerButtonHighlightView.frame.size.height);
    self.sellerButtonHighlightView.frame = CGRectMake(receivingButton.frame.origin.x, self.sellerButtonHighlightView.frame.origin.y, receivingButton.frame.size.width, self.sellerButtonHighlightView.frame.size.height);
    [UIView commitAnimations];
    
    
}

-(IBAction)favoritesButtonHit
{
    NSLog(@"favoritesButtonHit");
    
    if ([self.theTableView superview] == nil)
        [self.view addSubview:self.theTableView];
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    
    self.buyerFavoritesButton.selected = YES;
    self.infoButton.selected = NO;
    self.reviewsButton.selected = NO;
    
    [self animateSellerButton:self.buyerFavoritesButton];
    
}

-(IBAction) productsButtonHit
{
    if ([self.theTableView superview] == nil)
        [self.view addSubview:self.theTableView];
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    self.sellerProductsButton.selected = YES;
    self.sellerInfoButton.selected = NO;
    self.sellerReviewsButton.selected = NO;
    
    [self animateSellerButton:self.sellerProductsButton];
}

-(IBAction) infoButtonHit
{
    if ([self.theTableView superview] != nil)
        [self.theTableView removeFromSuperview];
    
    if ([self.infoContainerScrollView superview] == nil)
        [self.view addSubview:self.infoContainerScrollView];
    
    self.sellerProductsButton.selected = NO;
    self.sellerInfoButton.selected = YES;
    self.sellerReviewsButton.selected = NO;
    
    
    self.buyerFavoritesButton.selected = NO;
    self.infoButton.selected = YES;
    self.reviewsButton.selected = NO;
    
    [self animateSellerButton:self.sellerInfoButton];
}

-(IBAction) reviewsButtonHit
{
    if ([self.theTableView superview] != nil)
        [self.theTableView removeFromSuperview];
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    
    self.sellerProductsButton.selected = NO;
    self.sellerInfoButton.selected = NO;
    self.sellerReviewsButton.selected = YES;
    
    
    self.buyerFavoritesButton.selected = NO;
    self.infoButton.selected = NO;
    self.reviewsButton.selected = YES;
    
    [self animateSellerButton:self.sellerReviewsButton];
}





-(IBAction) imagePickButtonHit
{
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        GKImagePicker *imagePicker = [[GKImagePicker alloc] init];
        imagePicker.cropSize = CGSizeMake(self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        imagePicker.delegate = self;
        imagePicker.resizeableCropArea = NO;
        
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.appRootViewController presentViewController:imagePicker.imagePickerController animated:YES completion:nil];
    }
    
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
    
    [SellersAPIHandler uploadProfileImage:image withDelegate:self];
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
    
    [SellersAPIHandler uploadProfileImage:image withDelegate:self];
}

- (void) loadTheProfileImageViewWithID:(NSString *)theID
{
    [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:theID];
}


@end
