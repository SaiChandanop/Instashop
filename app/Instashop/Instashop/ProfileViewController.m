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


#define EDIT_TEXT @"edit your description"


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
    
    UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    NSLog(@"profileInstagramID: %@", profileInstagramID);
    NSLog(@"[InstagramUserObject getStoredUserObject].userID: %@",[InstagramUserObject getStoredUserObject].userID);
    NSLog(@"self.imagePickButton: %@", self.imagePickButton);
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
    {
        NSLog(@"remove");
        [self.imagePickButton removeFromSuperview];
    }
    
    
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = self.bioLabel.textColor;
    self.descriptionTextView.font = self.bioLabel.font;
    
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
            
            NSLog(@"here here");
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
        [facebookController addImage:self.profileImageView.image];
        [facebookController addURL:[NSURL URLWithString:@"http://alchemy50.com"]];
        [facebookController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:facebookController animated:YES completion:nil];
        
        
        
    }
    
    else if ([buttonTitle compare:@"Twitter"] == NSOrderedSame)
    {
        SLComposeViewController *tweetController = [SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            NSLog(@"here here");
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
        [tweetController addImage:self.profileImageView.image];
        [tweetController addURL:[NSURL URLWithString:@"http://alchemy50.com"]];
        [tweetController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:tweetController animated:YES completion:nil];
        
    }
    
    else if ([buttonTitle compare:@"Instagram"] == NSOrderedSame)
    {
                    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;

        NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            CGRect rect = CGRectMake(0,0,0,0);
            CGRect cropRect=CGRectMake(0,0,612,612);
            NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.ig"];
            CGImageRef imageRef = CGImageCreateWithImageInRect([self.backgroundImageView.image CGImage], cropRect);
            UIImage *img = [UIImage imageNamed:@"AppIcon76x76.png"];//[[UIImage alloc] initWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            BOOL writeSuccess = [UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];

            
            NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
            UIDocumentInteractionController *dicot = [[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile] retain];
            dicot.delegate = del;
            dicot.UTI = @"com.instagram.photo";
            dicot.annotation = [NSDictionary dictionaryWithObject:@"Caption" forKey:@"InstagramCaption"];
            [dicot presentOpenInMenuFromRect: rect  inView: [AppRootViewController sharedRootViewController].view animated: YES ];
            

            [del loadShareCoverViewWithImage:img];
        }
    }
    
}



- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    self.infoContainerScrollView.frame = self.theTableView.frame;
    
    
    /*
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
     */
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
    
    
    /*
     }
     
     if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
     self.profileBackgroundPhotoButton.alpha = .5;
     */
    
    
    
    
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
    
    [self loadTheProfileImageViewWithID:[InstagramUserObject getStoredUserObject].userID];
    
    
    self.bioLabel.text = [InstagramUserObject getStoredUserObject].bio;
    [self handleBioLayout];
    
}

-(void) backButtonHit
{
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
    self.infoContainerScrollView.contentSize = CGSizeMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 4);
    
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
    self.buttonHighlightView.frame = CGRectMake(receivingButton.frame.origin.x, self.buttonHighlightView.frame.origin.y, receivingButton.frame.size.width, self.buttonHighlightView.frame.size.height);
    [UIView commitAnimations];
    
    
}


-(IBAction) productsButtonHit
{
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


-(void)editButtonHit
{
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonHit)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    if ([self.descriptionTextView.text compare:EDIT_TEXT] == NSOrderedSame)
        self.descriptionTextView.text = @"";
    self.descriptionTextView.editable = YES;
    [self.descriptionTextView becomeFirstResponder];
    self.enclosingScrollView.contentSize = CGSizeMake(0, self.enclosingScrollView.frame.size.height * 1.5);
    [self.enclosingScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    
}

-(void)saveButtonHit
{
    [SellersAPIHandler updateSellerDescriptionWithDelegate:self InstagramID:[InstagramUserObject getStoredUserObject].userID withDescription:self.descriptionTextView.text];
    [self.descriptionTextView resignFirstResponder];
    [self.enclosingScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.enclosingScrollView.contentSize = CGSizeMake(0,0);
    self.descriptionTextView.editable = NO;
    
}


-(IBAction) infoButtonHit
{
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    else
    {
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
