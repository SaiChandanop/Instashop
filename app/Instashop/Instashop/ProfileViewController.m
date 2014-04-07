//
//  ProfileViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "AppRootViewController.h"
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
#import "Flurry.h"
#import "CacheManager.h"

@interface ProfileViewController ()

@end



@implementation ProfileViewController


#define EDIT_TEXT @"This user has not added a Description."

@synthesize theTableViewController;
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
@synthesize imagePickButton;
@synthesize hasAppeared;
@synthesize editButton;
@synthesize imagePicker;
@synthesize infoWebContainerView;
@synthesize webLabel;
@synthesize siteString;
@synthesize followContainerView;
@synthesize sellerContentButtonsView;
@synthesize followersTextLabel;
@synthesize followersValueLabel;
@synthesize followingTextLabel;
@synthesize followingValueLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tableDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
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
    self.followButton.layer.shadowOpacity = .2;
    self.followButton.layer.shadowRadius = 3;
    self.followButton.layer.shadowOffset = CGSizeMake(1, 0);
    //    self.followButton.layer.cornerRadius = 2;
    
    self.followButton.alpha = 0;
    
    
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
    
    
    
    [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:self.profileInstagramID];
    [self.view bringSubviewToFront:self.profileImageView];
    
    self.webLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, 0, 200, self.infoWebContainerView.frame.size.height - 2)];
    self.webLabel.backgroundColor = [UIColor clearColor];
    self.webLabel.font = self.bioLabel.font;
    self.webLabel.textColor = [ISConstants getISGreenColor];
    [self.infoWebContainerView addSubview:self.webLabel];
    
    UIImageView *webImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"URL.png"]];
    webImageView.frame = CGRectMake(7.5, 4.99, self.infoWebContainerView.frame.size.height - 10, self.infoWebContainerView.frame.size.height - 10);
    [self.infoWebContainerView addSubview:webImageView];
    
    UIButton *siteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    siteButton.frame = CGRectMake(0, 0, self.webLabel.frame.origin.x + self.webLabel.frame.size.width, self.infoWebContainerView.frame.size.height);
    [siteButton addTarget:self action:@selector(siteButtonHit) forControlEvents:UIControlEventTouchUpInside];
    siteButton.backgroundColor = [UIColor clearColor];
    [self.infoWebContainerView addSubview:siteButton];
    
    self.infoContainerScrollView.alpha = 0;
    
    self.theTableViewController = [[ProductSelectTableViewController alloc] initWithNibName:@"ProductSelectTableViewController" bundle:nil];
    self.theTableViewController.tableView.backgroundColor = [UIColor whiteColor];
    self.theTableViewController.cellDelegate = self;
    self.theTableViewController.profileViewController = self;
    
    float initialPoint = self.sellerContentButtonsView.frame.origin.y + self.sellerContentButtonsView.frame.size.height;
    self.theTableViewController.tableView.frame = CGRectMake(0, initialPoint, self.view.frame.size.width, self.view.frame.size.height - initialPoint);
    [self.view addSubview:self.theTableViewController.tableView];
    
    self.followContainerView.alpha = 0;
    
    
    
}


-(void)tableViewControllerDidLoadWithController:(ProductSelectTableViewController *)theProductSelectTableViewController
{
    NSLog(@"tableViewControllerDidLoadWithController[%d}: %@", theProductSelectTableViewController.productRequestorType, theProductSelectTableViewController.contentArray);
    [self resizeTableViewWithContentArrayWithController:theProductSelectTableViewController];
    if ([theProductSelectTableViewController.contentArray count] > 0)
        if ([[theProductSelectTableViewController.contentArray objectAtIndex:0] isKindOfClass:[NSDictionary class]])
            [self.tableDataDictionary setObject:[NSArray arrayWithArray:theProductSelectTableViewController.contentArray] forKey:[NSNumber numberWithInt:theProductSelectTableViewController.productRequestorType]];
}

-(void)resizeTableViewWithContentArrayWithController:(ProductSelectTableViewController *)theProductSelectTableViewController
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    int count = [theProductSelectTableViewController.contentArray count];
    float height = [theProductSelectTableViewController tableView:theProductSelectTableViewController.tableView heightForRowAtIndexPath:indexPath];
    
    if (count > 5)
        //    if (height > self.enclosingScrollView.frame.size.height)
    {
        
        float totalHeight = (count / 3) * height;
        
        theProductSelectTableViewController.tableView.frame = CGRectMake(theProductSelectTableViewController.tableView.frame.origin.x, theProductSelectTableViewController.tableView.frame.origin.y, theProductSelectTableViewController.tableView.frame.size.width, totalHeight);
        theProductSelectTableViewController.tableView.scrollEnabled = NO;
        self.enclosingScrollView.contentSize = CGSizeMake(0, theProductSelectTableViewController.tableView.frame.origin.y + theProductSelectTableViewController.tableView.frame.size.height);
    }
}


-(void)moreButtonHit
{
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Instagram", nil];
    shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [shareActionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
}

- (void) actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [theActionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle compare:@"Facebook"] == NSOrderedSame)
    {
        
        NSString *flurryString = [NSString stringWithFormat:@"Prmoted on Facebook"];
        [Flurry logEvent:flurryString];
        
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
        
        NSString *postText = [NSString stringWithFormat:@"Checkout Shopsy, the place to shop for products discovered on Instagram"];
        [facebookController setInitialText:postText];
        [facebookController addImage:[UIImage imageNamed:@"Instagram-Promo-1.jpg"]];
        [facebookController addURL:[NSURL URLWithString:@"http://shopsy.com/download"]];
        [facebookController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:facebookController animated:YES completion:nil];
        
        
        
    }
    
    else if ([buttonTitle compare:@"Twitter"] == NSOrderedSame)
    {
        NSString *flurryString = [NSString stringWithFormat:@"Prmoted on Twitter"];
        [Flurry logEvent:flurryString];
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
        
        NSString *postText = [NSString stringWithFormat:@"Checkout @shopsyapp, the place to shop for products discovered on Instagram"];
        [tweetController setInitialText:postText];
        [tweetController addImage:[UIImage imageNamed:@"Instagram-Promo-1.jpg"]];
        [tweetController addURL:[NSURL URLWithString:@"http://shopsy.com/download"]];
        [tweetController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:tweetController animated:YES completion:nil];
        
    }
    
    else if ([buttonTitle compare:@"Instagram"] == NSOrderedSame)
    {
        
        NSString *flurryString = [NSString stringWithFormat:@"Prmoted on Instagram"];
        [Flurry logEvent:flurryString];
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
        self.infoContainerScrollView.alpha = 0;
        
        self.hasAppeared = YES;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
        
        float initialPoint = self.sellerContentButtonsView.frame.origin.y + self.sellerContentButtonsView.frame.size.height;
        self.theTableViewController.tableView.frame = CGRectMake(0, initialPoint, self.view.frame.size.width, self.view.frame.size.height - initialPoint);
        [self.enclosingScrollView addSubview:self.theTableViewController.tableView];
        
        self.infoContainerScrollView.frame = self.theTableViewController.tableView.frame;
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", self.profileInstagramID], @"method", @"-1", @"count", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
        
        [self productsButtonHit];
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
    self.requestedInstagramProfileObject = [[NSDictionary alloc] initWithDictionary:theReqeustedProfileObject];
    self.usernameLabel.text = [self.requestedInstagramProfileObject objectForKey:@"full_name"];
    [self setTitleViewText:[self.requestedInstagramProfileObject objectForKey:@"username"]];
    [self updateProfileView:[self.requestedInstagramProfileObject objectForKey:@"id"]];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedInstagramProfileObject objectForKey:@"profile_picture"] withImageView:self.profileImageView];
    
    NSDictionary *countsDictionary = [self.requestedInstagramProfileObject objectForKey:@"counts"];
    
    
    self.followContainerView.layer.cornerRadius = 5;
    self.followContainerView.layer.masksToBounds = YES;
    self.followContainerView.alpha = 1.0;
    
    /*
    self.followersTextLabel.font = [UIFont systemFontOfSize:9];
    self.followersTextLabel.textColor = [UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    self.followingTextLabel.font = self.followersTextLabel.font;
    self.followingTextLabel.textColor = self.followersTextLabel.textColor;
    
    self.followersValueLabel.font = [UIFont systemFontOfSize:11];
    self.followersValueLabel.textColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1];
    self.followingValueLabel.font = self.followersValueLabel.font;
    self.followingValueLabel.textColor = self.followersValueLabel.textColor;
    */
    
    self.followersValueLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"followed_by"] integerValue]];
    self.followingValueLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"follows"] integerValue]];
    
    
    [SellersAPIHandler getSellerDetailsWithInstagramID:[self.requestedInstagramProfileObject objectForKey:@"id"] withDelegate:self];
    
    
    self.bioLabel.text = [self.requestedInstagramProfileObject objectForKey:@"bio"];
    [self handleBioLayout];
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/relationship", [self.requestedInstagramProfileObject objectForKey:@"id"]], @"method", nil];
    [delegate.instagram requestWithParams:params delegate:self];
    
    
    
    
}

-(IBAction)followOnInstagramButtonHit
{
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!self.followButton.selected)
    {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", [self.requestedInstagramProfileObject objectForKey:@"id"]], @"method", @"follow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
        
        
        NSString *flurryString = [NSString stringWithFormat:@"User followed"];
        NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self.requestedInstagramProfileObject objectForKey:@"id"], @"user", nil];
        [Flurry logEvent:flurryString withParameters:flurryParams];
    }
    else
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", [self.requestedInstagramProfileObject objectForKey:@"id"]], @"method", @"unfollow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
        
        NSString *flurryString = [NSString stringWithFormat:@"User unfollowed"];
        NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self.requestedInstagramProfileObject objectForKey:@"id"], @"user", nil];
        [Flurry logEvent:flurryString withParameters:flurryParams];
    }
}

- (void)request:(IGRequest *)request didLoad:(id)result
{
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *resultDict = (NSDictionary *)result;
    if (resultDict != nil)
    {
        NSDictionary *dataDictionary = [resultDict objectForKey:@"data"];
        if ([dataDictionary isKindOfClass:[NSDictionary class]])
            if (dataDictionary != nil)
            {
                NSString *websiteString = [dataDictionary objectForKey:@"website"];
                if (websiteString != nil)
                {
                    self.siteString = [NSString stringWithString:websiteString];
                    websiteString = [websiteString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                    websiteString = [websiteString stringByReplacingOccurrencesOfString:@"www." withString:@""];
                    self.webLabel.text = websiteString;
                }
            }
    }
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        if ([request.url rangeOfString:@"media"].length > 0)
        {
            
        }
        else if ([request.url rangeOfString:@"relationship"].length > 0)
        {
            NSDictionary *dict = [result objectForKey:@"data"];
            NSString *outgoingStatus = [dict objectForKey:@"outgoing_status"];
            
            if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
            {
                if ([outgoingStatus compare:@"follows"] == NSOrderedSame)
                    self.followButton.alpha = 0;
                else
                    self.followButton.alpha = 1;
            }
        }
        else if ([request.url rangeOfString:@"users"].length > 0)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            [self loadViewsWithRequestedProfileObject:dataDictionary];
        }
    }
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request[%@]: error: %@", request.url, error);
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
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    if ([self.theTableViewController.tableView superview] == nil)
        [self.enclosingScrollView addSubview:self.theTableViewController.tableView];
    
    
    
    self.productsButton.selected = YES;
    self.infoButton.selected = NO;
    self.favoritesButton.selected = NO;
    
    [self animateSellerButton:self.productsButton];
    
    
    NSArray *theContentArray = [self.tableDataDictionary objectForKey:[NSNumber numberWithInt:PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER]];
    
    NSLog(@"PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER: %d", PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER);
    NSLog(@"self.tableDataDictionary: %@", self.tableDataDictionary);
    
    BOOL hardRefresh = YES;
    if (theContentArray != nil)
        if ([theContentArray count] > 0)
        {
            NSLog(@"count: %d", [theContentArray count]);
            hardRefresh = NO;
            self.theTableViewController.contentArray = [[NSMutableArray alloc] initWithArray:theContentArray];
            [self.theTableViewController.tableView reloadData];
        }
    
    if (hardRefresh)
    {
        NSLog(@"do hard refresh");
        
        [self.theTableViewController.contentArray removeAllObjects];
        [self.theTableViewController.tableView reloadData];
        
        self.theTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER;
        self.theTableViewController.productRequestorReferenceObject = self.profileInstagramID;
        [self.theTableViewController refreshContent];
    }
    
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
        
    }
    
}

-(void)saveButtonHit
{
    [self.editButton setTitle:@"EDIT" forState:UIControlStateNormal];
    [SellersAPIHandler updateSellerDescriptionWithDelegate:self InstagramID:[InstagramUserObject getStoredUserObject].userID withDescription:self.descriptionTextView.text];
    [self.descriptionTextView resignFirstResponder];
    self.enclosingScrollView.contentSize = CGSizeMake(0,0);
    self.descriptionTextView.editable = NO;
    
    if ([self.editButton superview] == self.view)
        self.editButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.editButton.frame.size.height - 64, self.editButton.frame.size.width, self.editButton.frame.size.height);
}


-(IBAction) infoButtonHit
{
    self.infoContainerScrollView.alpha = 1;
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] != NSOrderedSame)
        self.editButton.alpha = 0;
    else
    {
        self.editButton.alpha = 1;
        UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    if ([self.theTableViewController.tableView superview] != nil)
        [self.theTableViewController.tableView removeFromSuperview];
    
    if ([self.infoContainerScrollView superview] == nil)
        [self.enclosingScrollView addSubview:self.infoContainerScrollView];
    
    
    self.productsButton.selected = NO;
    self.infoButton.selected = YES;
    self.favoritesButton.selected = NO;
    
    [self animateSellerButton:self.infoButton];
    
    
    [self.view bringSubviewToFront:self.editButton];
    
    self.enclosingScrollView.contentSize = CGSizeMake(0, self.editButton.frame.origin.y + self.editButton.frame.size.height);
}

-(IBAction)favoritesButtonHit
{
    NSLog(@"favoritesButtonHit");
    
    
    
    
    if ([self.infoContainerScrollView superview] != nil)
        [self.infoContainerScrollView removeFromSuperview];
    
    if ([self.theTableViewController.tableView superview] == nil)
        [self.enclosingScrollView addSubview:self.theTableViewController.tableView];
    
    
    self.favoritesButton.selected = YES;
    self.infoButton.selected = NO;
    self.productsButton.selected = NO;
    [self animateSellerButton:self.favoritesButton];
    
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonHit)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    NSLog(@"PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER: %d", PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER);
    NSLog(@"self.tableDataDictionary: %@", self.tableDataDictionary);
    
    
    NSArray *theContentArray = [self.tableDataDictionary objectForKey:[NSNumber numberWithInt:PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER]];
    BOOL hardRefresh = YES;
    if (theContentArray != nil)
        if ([theContentArray count] > 0)
        {
            hardRefresh = NO;
            self.theTableViewController.contentArray = [[NSMutableArray alloc] initWithArray:theContentArray];
            [self.theTableViewController.tableView reloadData];
        }
    if (hardRefresh)
    {
        [self.theTableViewController.contentArray removeAllObjects];
        [self.theTableViewController.tableView reloadData];
        self.theTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER;
        [self.theTableViewController refreshContent];
    }
}




-(IBAction) imagePickButtonHit
{
    
    if ([self.profileInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
    {
        self.imagePicker = [[GKImagePicker alloc] init];
        //        imagePicker.cropSize = CGSizeMake(self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        self.imagePicker.cropSize = CGSizeMake(self.backgroundImageView.frame.size.width, self.backgroundImageView.frame.size.height);
        self.imagePicker.delegate = self;
        self.imagePicker.resizeableCropArea = NO;
        
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.appRootViewController presentViewController:imagePicker.imagePickerController animated:YES completion:nil];
    }
    
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    NSLog(@"imagePicker did pick image");
    
    
    NSString *deleteString = [NSString stringWithFormat:@"%@/upload/%@.jpeg", [ROOT_URI stringByReplacingOccurrencesOfString:@"www." withString:@""], [InstagramUserObject getStoredUserObject].userID];
    [[CacheManager getSharedCacheManager] destroyCachedImageWithURL:deleteString];
    
    
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
    
    if ([object isKindOfClass:[NSTimer class]])
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:[((NSTimer *)object) userInfo]];
    else
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.backgroundImageView withInstagramID:object];
    
}

-(void)siteButtonHit
{
    if (self.siteString != nil)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.siteString]]];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0,-20, self.view.frame.size.width, 40)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [webView addSubview:whiteView];
        
        UIViewController *containerViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        containerViewController.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
        [containerViewController.view addSubview:webView];
        
        UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
        gapView.backgroundColor = [UIColor whiteColor];
        [containerViewController.view addSubview:gapView];
        
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(0,20, 20, 20);
        exitButton.backgroundColor = [UIColor redColor];
        [exitButton addTarget:self action:@selector(exitButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [gapView addSubview:exitButton];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:containerViewController animated:YES completion:nil];
    }
}

-(void)exitButtonHit
{
    [[AppRootViewController sharedRootViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (void) productSelectTableViewControllerDidLoadData:(ProductSelectTableViewController *)theProductSelectTableViewController
{
    
}



-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
    }
    [super viewWillDisappear:animated];
}


- (void)dealloc
{
    NSLog(@"profile dealloc");
    
}
@end
