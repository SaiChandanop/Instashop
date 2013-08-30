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
@synthesize sellerInfoView;
@synthesize infoView;
@synthesize productSelectTableViewController;
@synthesize theTableView;
@synthesize followersButton;
@synthesize followingButton;
@synthesize profileBackgroundPhotoButton;
@synthesize bioTextView;
@synthesize titleViewLabel;
@synthesize isSelfProfile;
@synthesize followButton;
@synthesize requestedInstagramProfileObject;

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
    
    self.followButton.backgroundColor = [ISConstants getISGreenColor];
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

    
    self.infoView.frame = self.theTableView.frame;



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
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
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
    self.bioTextView.text = [InstagramUserObject getStoredUserObject].bio;
    
    [self loadTheProfileImageViewWithID:[InstagramUserObject getStoredUserObject].userID];
    
    
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



-(void)loadViewsWithRequestedProfileObject:(NSDictionary *)theReqeustedProfileObject
{
    self.requestedInstagramProfileObject = [[NSDictionary alloc] initWithDictionary:theReqeustedProfileObject];
    
    self.bioTextView.text = [self.requestedInstagramProfileObject objectForKey:@"bio"];
    self.usernameLabel.text = [self.requestedInstagramProfileObject objectForKey:@"full_name"];
    [self setTitleViewText:[self.requestedInstagramProfileObject objectForKey:@"username"]];
    
    [self loadTheProfileImageViewWithID:[self.requestedInstagramProfileObject objectForKey:@"id"]];
    
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedInstagramProfileObject objectForKey:@"profile_picture"] withImageView:self.profileImageView];
    
    NSDictionary *countsDictionary = [self.requestedInstagramProfileObject objectForKey:@"counts"];
    [self.followersButton setTitle:[NSString stringWithFormat:@"%d%@", [[countsDictionary objectForKey:@"followed_by"] integerValue], @" Followers"] forState:UIControlStateNormal];
    [self.followingButton setTitle:[NSString stringWithFormat:@"%d%@", [[countsDictionary objectForKey:@"follows"] integerValue], @" Following"] forState:UIControlStateNormal];
    
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
        self.followButton.alpha = 1;

    
}

-(IBAction)followOnInstagramButtonHit
{
    /*    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
     NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/280421250/relationship", @"method", @"follow", @"action", nil];
     [theAppDelegate.instagram postRequestWithParams:params delegate:self];
     */

    
    
}
- (void)request:(IGRequest *)request didLoad:(id)result
{
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        if ([request.url rangeOfString:@"media"].length > 0)
        {

        }
        else if ([request.url rangeOfString:@"users"].length > 0)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            [self loadViewsWithRequestedProfileObject:dataDictionary];
    
        }
    }
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
    
    if ([self.infoView superview] != nil)
        [self.infoView removeFromSuperview];
    
    
    self.buyerFavoritesButton.selected = YES;
    self.infoButton.selected = NO;
    self.reviewsButton.selected = NO;
    
    [self animateSellerButton:self.buyerFavoritesButton];
    
}

-(IBAction) productsButtonHit
{
    if ([self.theTableView superview] == nil)
        [self.view addSubview:self.theTableView];
    
    if ([self.infoView superview] != nil)
        [self.infoView removeFromSuperview];
    
    self.sellerProductsButton.selected = YES;
    self.sellerInfoButton.selected = NO;
    self.sellerReviewsButton.selected = NO;
    
    [self animateSellerButton:self.sellerProductsButton];
}

-(IBAction) infoButtonHit
{
    if ([self.theTableView superview] != nil)
        [self.theTableView removeFromSuperview];
    
    if ([self.infoView superview] == nil)
        [self.view addSubview:self.infoView];
    
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
    
    if ([self.infoView superview] != nil)
        [self.infoView removeFromSuperview];
    
    
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
