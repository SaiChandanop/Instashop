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
#import <Social/Social.h>
#import "SocialManager.h"

@interface ProfileViewController ()

@end



@implementation ProfileViewController


#define EDIT_TEXT @"This user has not added a Description."


@synthesize enclosingScrollView;
@synthesize profileInstagramID;

@synthesize backgroundImageView;
@synthesize addBackgroundImageButton;
@synthesize profileImageView;
@synthesize usernameLabel;

@synthesize productsButton;
@synthesize infoButton;
@synthesize favoritesButton;
@synthesize buttonHighlightView;
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
@synthesize descriptionTextView;
@synthesize favoritesSelectTableViewController;
@synthesize imagePickButton;
@synthesize hasAppeared;
@synthesize editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(IBAction) reviewsButtonHit
{
    
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    [super viewDidLoad];
    self.buttonHighlightView.backgroundColor = [ISConstants getISGreenColor];
    
    self.productsButton.selected = YES;
    self.infoButton.selected = NO;
    self.favoritesButton.selected = NO;
    
    self.followButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.followButton.layer.shadowOpacity = .75;
    self.followButton.layer.shadowRadius = 2.5;
    self.followButton.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.followButton.layer.cornerRadius = 2;
    
    self.followButton.alpha = 0;
    
    NSLog(@"self.profileInstagramID: %@", self.profileInstagramID);
    NSLog(@"[InstagramUserObject getStoredUserObject].userID: %@", [InstagramUserObject getStoredUserObject].userID);
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
        [self.imagePickButton removeFromSuperview];
    else
    {
        UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = self.bioLabel.textColor;
    self.descriptionTextView.font = self.bioLabel.font;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
    NSLog(@"begin profile view controller");

    /*
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.editButton removeFromSuperview];
        self.editButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.editButton.frame.size.height - 64, self.editButton.frame.size.width, self.editButton.frame.size.height);
        [self.view addSubview:self.editButton];
        self.editButton.alpha = 0;
    }
    NSLog(@"self.editButton: %@", self.editButton);
     */
}


-(void)moreButtonHit
{
    NSLog(@"moreButtonHit");
    
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Instagram", nil];
    shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [shareActionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
    
}

- (void) actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [theActionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle compare:@"Facebook"] == NSOrderedSame)
    {
        [SocialManager requestInitialFacebookAccess];
        
        SLComposeViewController *facebookController = [SLComposeViewController
                                                       composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [facebookController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"SLComposeViewControllerResultCancelled");
                default:
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"SLComposeViewControllerResultDone");
                    break;
            }};
        
        NSString *postText = [NSString stringWithFormat:@"promo!"];
        [facebookController setInitialText:postText];
        [facebookController addImage:[UIImage imageNamed:@"Instagram-Promo-1.png"]];
        [facebookController addURL:[NSURL URLWithString:@"http://shopsy.com"]];
        [facebookController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:facebookController animated:YES completion:nil];
        
        
        
    }
    
    else if ([buttonTitle compare:@"Twitter"] == NSOrderedSame)
    {
        SLComposeViewController *tweetController = [SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [tweetController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"SLComposeViewControllerResultCancelled");
                default:
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"SLComposeViewControllerResultDone");
                    break;
            }};
        
        NSString *postText = [NSString stringWithFormat:@"promo!"];
        [tweetController setInitialText:postText];
        [tweetController addImage:[UIImage imageNamed:@"Instagram-Promo-1.png"]];
        [tweetController addURL:[NSURL URLWithString:@"http://shopsy.com"]];
        [tweetController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:tweetController animated:YES completion:nil];
        
    }
    
    else if ([buttonTitle compare:@"Instagram"] == NSOrderedSame)
    {
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {                        
            [del loadShareCoverViewProfileViewController:self];
        }
    }
    
}



- (void)viewDidAppear:(BOOL)animated
{
    if (!self.hasAppeared)
    {
        self.hasAppeared = YES;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
        self.infoContainerScrollView.frame = self.theTableView.frame;
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", self.profileInstagramID], @"method", @"-1", @"count", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
        self.productSelectTableViewController.cellDelegate = self;
        self.productSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER;
        self.productSelectTableViewController.productRequestorReferenceObject = self.profileInstagramID;
        [self.productSelectTableViewController refreshContent];
        
        self.favoritesSelectTableViewController = [[ProductSelectTableViewController alloc] initWithNibName:@"ProductSelectTableViewController" bundle:nil];
        self.favoritesSelectTableViewController.tableView.frame = self.productSelectTableViewController.tableView.frame;
        self.favoritesSelectTableViewController.cellDelegate = self;
        self.favoritesSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER;
        self.favoritesSelectTableViewController.productRequestorReferenceObject = self.profileInstagramID;
        [self.favoritesSelectTableViewController refreshContent];
    }
    
}


-(void)sellerDetailsResopnseDidOccurWithDictionary:(NSDictionary *)responseDictionary
{    
    if ([responseDictionary isKindOfClass:[NSDictionary class]])
    {
        NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@", [responseDictionary objectForKey:@"seller_address"], [responseDictionary objectForKey:@"seller_city"], [responseDictionary objectForKey:@"seller_state"]];
        self.addressLabel.text = addressString;
        self.emailLabel.text = [responseDictionary objectForKey:@"seller_email"];
        self.categoryLabel.text = [responseDictionary objectForKey:@"seller_category"];
        
        if (![[responseDictionary objectForKey:@"seller_description"] isKindOfClass:[NSNull class]])
            self.descriptionTextView.text = [responseDictionary objectForKey:@"seller_description"];
        else if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
            self.descriptionTextView.text = EDIT_TEXT;
    }
    
}




-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
    purchasingViewController.requestingProductID = [theSelectionObject objectForKey:@"product_id"];
    [self.navigationController pushViewController:purchasingViewController animated:YES];
    
}

-(void)loadNavigationControlls
{
    self.isSelfProfile = YES;
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setTitleViewText:[InstagramUserObject getStoredUserObject].username];
    self.usernameLabel.text = [InstagramUserObject getStoredUserObject].fullName;
    
    [self updateProfileView:[InstagramUserObject getStoredUserObject].userID];
    
    
    self.bioLabel.text = [InstagramUserObject getStoredUserObject].bio;
    [self handleBioLayout];
    
}

-(void) backButtonHit
{
    NSLog(@"backButtonHit");
    [self.descriptionTextView resignFirstResponder];
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
    float descSpacer = self.descriptionTextView.frame.origin.y - self.bioContainerImageView.frame.origin.y - self.bioContainerImageView.frame.size.height;
    self.bioLabel.numberOfLines = 0;
    CGSize bioLabelSize = [self.bioLabel.text sizeWithFont:self.bioLabel.font constrainedToSize:CGSizeMake(self.bioLabel.frame.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.bioLabel.frame = CGRectMake(self.bioLabel.frame.origin.x, self.bioLabel.frame.origin.y, self.bioLabel.frame.size.width, bioLabelSize.height + 1);
    self.bioContainerImageView.frame = CGRectMake(self.bioContainerImageView.frame.origin.x, self.bioContainerImageView.frame.origin.y, self.bioContainerImageView.frame.size.width, self.bioLabel.frame.size.height + 21);
    self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.bioContainerImageView.frame.origin.y + bioContainerImageView.frame.size.height + descSpacer, self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height);
    
    
    self.infoContainerScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightMenuBG.png"]];
    //    self.infoContainerScrollView.contentSize = CGSizeMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 4);
    
}


-(void)loadViewsWithRequestedProfileObject:(NSDictionary *)theReqeustedProfileObject
{
    NSLog(@"loadViewsWithRequestedProfileObject");
    
    self.requestedInstagramProfileObject = [[NSDictionary alloc] initWithDictionary:theReqeustedProfileObject];
    
    self.usernameLabel.text = [self.requestedInstagramProfileObject objectForKey:@"full_name"];
    [self setTitleViewText:[self.requestedInstagramProfileObject objectForKey:@"username"]];
    
    [self updateProfileView:[self.requestedInstagramProfileObject objectForKey:@"id"]];
    
    
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
    self.buttonHighlightView.frame = CGRectMake(receivingButton.frame.origin.x, self.buttonHighlightView.frame.origin.y, receivingButton.frame.size.width, self.buttonHighlightView.frame.size.height);
    [UIView commitAnimations];
    
    
}


-(IBAction) productsButtonHit
{
    self.editButton.alpha = 0;
    UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    if (self.favoritesSelectTableViewController != nil)
        [self.favoritesSelectTableViewController.tableView removeFromSuperview];
    
    
    if ([self.theTableView superview] == nil)
        [self.enclosingScrollView addSubview:self.theTableView];
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    self.productsButton.selected = YES;
    self.infoButton.selected = NO;
    self.favoritesButton.selected = NO;
    
    [self animateSellerButton:self.productsButton];
}


-(IBAction)editButtonHit
{
    NSLog(@"editButtonHit");
    if ([self.descriptionTextView isFirstResponder])
    {
        [self saveButtonHit];
    }
    else
    {
        [self.editButton setTitle:@"SAVE" forState:UIControlStateNormal];
        
        
        if ([self.descriptionTextView.text compare:EDIT_TEXT] == NSOrderedSame)
            self.descriptionTextView.text = @"";
        
        self.descriptionTextView.editable = YES;
        [self.descriptionTextView becomeFirstResponder];
        self.enclosingScrollView.contentSize = CGSizeMake(0, self.enclosingScrollView.frame.size.height);
        [self.enclosingScrollView setContentOffset:CGPointMake(0, 217) animated:YES];
        
        //if ([self.editButton superview] == self.view)
            //self.editButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.editButton.frame.size.height - 276, self.editButton.frame.size.width, self.editButton.frame.size.height);
    }
    
}

-(void)saveButtonHit
{
    [self.editButton setTitle:@"EDIT" forState:UIControlStateNormal];
    [SellersAPIHandler updateSellerDescriptionWithDelegate:self InstagramID:[InstagramUserObject getStoredUserObject].userID withDescription:self.descriptionTextView.text];
    [self.descriptionTextView resignFirstResponder];
    //    [self.enclosingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.enclosingScrollView.contentSize = CGSizeMake(0,0);
    self.descriptionTextView.editable = NO;
    
    if ([self.editButton superview] == self.view)
        self.editButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.editButton.frame.size.height - 64, self.editButton.frame.size.width, self.editButton.frame.size.height);
}


-(IBAction) infoButtonHit
{
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        self.editButton.alpha = 1;
        //        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonHit)];
        //        self.navigationItem.rightBarButtonItem = shareButton;
    }
    else
    {
        self.editButton.alpha = 0;
        UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    if (self.productSelectTableViewController != nil)
        [self.productSelectTableViewController.tableView removeFromSuperview];
    
    if (self.favoritesSelectTableViewController != nil)
        [self.favoritesSelectTableViewController.tableView removeFromSuperview];
    
    
    if ([self.theTableView superview] != nil)
        [self.theTableView removeFromSuperview];
    
    if ([self.infoContainerScrollView superview] == nil)
        [self.enclosingScrollView addSubview:self.infoContainerScrollView];
    
    
    
    self.productsButton.selected = NO;
    self.infoButton.selected = YES;
    self.favoritesButton.selected = NO;
    
    [self animateSellerButton:self.infoButton];
    

    [self.view bringSubviewToFront:self.editButton];
    
    
}

-(IBAction)favoritesButtonHit
{
    if (self.productSelectTableViewController != nil)
        [self.productSelectTableViewController.tableView removeFromSuperview];
    
    if ([self.theTableView superview] == nil)
        [self.enclosingScrollView addSubview:self.theTableView];
    
    if ([self.favoritesSelectTableViewController.tableView superview] == nil)
        [self.enclosingScrollView addSubview:self.favoritesSelectTableViewController.tableView];
    
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    
    self.favoritesButton.selected = YES;
    self.infoButton.selected = NO;
    self.productsButton.selected = NO;
    
    [self animateSellerButton:self.favoritesButton];
    
    UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
    self.navigationItem.rightBarButtonItem = shareButton;
}




-(IBAction) imagePickButtonHit
{
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        GKImagePicker *imagePicker = [[GKImagePicker alloc] init];
        //        imagePicker.cropSize = CGSizeMake(self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        imagePicker.cropSize = CGSizeMake(self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        imagePicker.delegate = self;
        imagePicker.resizeableCropArea = NO;
        
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.appRootViewController presentViewController:imagePicker.imagePickerController animated:YES completion:nil];
    }
    
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    NSLog(@"imagePicker did pick image");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.appRootViewController dismissViewControllerAnimated:YES completion:nil];
    
    [SellersAPIHandler uploadProfileImage:image withDelegate:nil];
    
    self.backgroundImageView.image = image;
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
    
    [SellersAPIHandler uploadProfileImage:image withDelegate:nil];
    
    self.backgroundImageView.image = image;
}

- (void) loadTheProfileImageViewWithID:(NSString *)theID
{
    NSLog(@"loadTheProfileImageViewWithID");
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateProfileView:) userInfo:theID repeats:NO];
    
    
}

-(void)updateProfileView:(id)object
{
    

    
    NSLog(@"object: %@", object);
    
    if ([object isKindOfClass:[NSTimer class]])
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:[((NSTimer *)object) userInfo]];
    else
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:object];
    
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"viewWillDisappear: %@", self);
        
        /*
         @property (nonatomic, retain) IBOutlet UIScrollView *enclosingScrollView;
         
         @property (nonatomic, retain) NSString *profileInstagramID;
         
         @property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
         @property (nonatomic, retain) IBOutlet UIButton *addBackgroundImageButton;
         
         @property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
         @property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
         
         @property (nonatomic, retain) IBOutlet UIButton *followersButton;
         @property (nonatomic, retain) IBOutlet UIButton *followingButton;
         
         @property (nonatomic, retain) IBOutlet UIButton *followButton;
         
         
         
         @property (nonatomic, retain) IBOutlet UIButton *productsButton;
         @property (nonatomic, retain) IBOutlet UIButton *infoButton;
         @property (nonatomic, retain) IBOutlet UIButton *favoritesButton;
         @property (nonatomic, retain) IBOutlet UIView *buttonHighlightView;
         
         
         @property (nonatomic, retain) IBOutlet UIButton *profileBackgroundPhotoButton;
         
         
         
         @property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
         @property (nonatomic, retain) IBOutlet ProductSelectTableViewController *favoritesSelectTableViewController;
         @property (nonatomic, retain) IBOutlet UITableView *theTableView;
         
         @property (nonatomic, retain) UILabel *titleViewLabel;
         
         @property (nonatomic, assign) BOOL isSelfProfile;
         
         @property (nonatomic, retain) NSDictionary *requestedInstagramProfileObject;
         
         @property (nonatomic, retain) IBOutlet UIScrollView *infoContainerScrollView;
         @property (nonatomic, retain) IBOutlet UILabel *addressLabel;
         @property (nonatomic, retain) IBOutlet UILabel *emailLabel;
         @property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
         @property (nonatomic, retain) IBOutlet UIImageView *bioContainerImageView;
         @property (nonatomic, retain) IBOutlet UILabel *bioLabel;
         @property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
         @property (nonatomic, retain) IBOutlet UIButton *editButton;
         @property (nonatomic, retain) IBOutlet UIButton *imagePickButton;
         */
    }
    [super viewWillDisappear:animated];
}


- (void)dealloc
{
    NSLog(@"profile dealloc");
    
}
@end
