//
//  PurchasingViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingViewController.h"
#import "ImageAPIHandler.h"
#import "FeedViewController.h"
#import "AppDelegate.h"
#import "ProductAPIHandler.h"
#import "SellersAPIHandler.h"
#import "SizePickerViewViewController.h"
#import "ProfileViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductPreviewViewController.h"
#import "CreateProductAPIHandler.h"
#import "EditProductCompleteProtocol.h"
#import "CIALBrowserViewController.h"
#import "ViglinkAPIHandler.h"
#import "SocialManager.h"
#import <Social/Social.h>
#import "AmberViewController.h"
#import "AmberAPIHandler.h"
#import "NotificationsAPIHandler.h"
#import "SavedItemsAPIHandler.h"
#import "BitlyAPIHandler.h"
#import "SearchButtonContainerView.h"
#import "Flurry.h"

@interface PurchasingViewController ()

@property (nonatomic, strong) NSDictionary *requestedProductObject;

@end

@implementation PurchasingViewController

@synthesize heartImageView;
@synthesize doubleTapView;
@synthesize sizePickerViewViewController;
@synthesize requestingProductID;
@synthesize requestedPostmasterDictionary;
@synthesize contentScrollView;
@synthesize descriptionContainerView;
@synthesize requestedProductObject;
@synthesize imageView, sellerLabel, likesLabel, descriptionTextView, listPriceLabel, retailPriceLabel, numberAvailableLabel, sellerProfileImageView;
@synthesize bottomView;
@synthesize sizeSelectedIndex;
@synthesize purchaseButton;
@synthesize likesArray;
@synthesize actionSheet;
@synthesize quantityButton;
@synthesize sizeButton;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize viglinkString;
@synthesize commentsTableViewController;
@synthesize commentTextField;
@synthesize commentExitButton;
@synthesize cialBrowserViewController;
@synthesize isEditable;
@synthesize saveButton;
@synthesize isBuying;
@synthesize categoryContainerView;
@synthesize categoryContainerImageView;
@synthesize categoryContainerBottomSeparatorImageView;
@synthesize JKProgressView;
@synthesize searchViewControllerDelegate;
@synthesize searchCategoriesArray;
@synthesize descriptionContentSizeSet;
@synthesize descriptionContentSize;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setViewSpacing
{
    if (!self.descriptionContentSizeSet)
    {
        NSLog(@"setViewSpacing, initial");
        self.descriptionContentSizeSet = YES;
        self.descriptionContentSize = self.descriptionTextView.contentSize;
    }
    else if (self.descriptionTextView.contentSize.height > self.descriptionContentSize.height)
    {
        NSLog(@"setViewSpacing, do resize");
 
        self.descriptionContentSize = self.descriptionTextView.contentSize;
        self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.contentSize.height);
        self.commentsTableViewController.view.frame = CGRectMake(0, self.commentsTableViewController.view.frame.origin.y, self.commentsTableViewController.view.frame.size.width, 44 * 4);
        self.contentScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.bottomView.frame.size.height);
        self.contentScrollView.contentSize = CGSizeMake(0, self.categoryContainerView.frame.origin.y + self.categoryContainerView.frame.size.height + self.descriptionTextView.frame.size.height);

    }
    else
    {
        NSLog(@"setViewSpacing, ignore");
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonHit)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.doubleTapView addGestureRecognizer:tapGestureRecognizer];
    
//    NSLog(@"viewDidAppear, self.descriptionTextView.contentSize: %@", NSStringFromCGSize(self.descriptionTextView.contentSize));
    
    [self setViewSpacing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
//    NSLog(@"requestingProductID: %@", self.requestingProductID);
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self withInstagramID:[InstagramUserObject getStoredUserObject].userID];
    
    self.sizeSelectedIndex = 0;
    self.descriptionTextView.text = @"";
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarShopsyLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
    
    self.sizeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.sizeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.quantityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.quantityButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.retailPriceLabel.alpha = 0;
    self.listPriceLabel.alpha = 0;
    self.numberAvailableLabel.alpha = 0;
    
    //    self.commentsTableViewController.tableView.userInteractionEnabled = NO;
    self.commentsTableViewController.view.backgroundColor = [UIColor clearColor];
    self.commentsTableViewController.tableView.backgroundColor = [UIColor clearColor];
    self.commentsTableViewController.tableView.separatorColor = [UIColor clearColor];
    self.commentsTableViewController.parentController = self;
    //    self.commentsTableViewController.commentsDataArray = [[NSArray alloc] initWithObjects:[NSNull null], nil];
    [self.commentsTableViewController.tableView reloadData];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
    
    NSString *flurryString = [NSString stringWithFormat:@"User viewed"];
    NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:self.requestingProductID, @"product_id", nil];
    [Flurry logEvent:flurryString withParameters:flurryParams];
    
    [self setViewSpacing];
}

-(void)searchButtonContainerHit:(SearchButtonContainerView *)theButton
{
    if (self.searchViewControllerDelegate != nil)
    {
        [self.searchViewControllerDelegate purchasingViewControllerSearchFiredWithString:theButton.searchLabel.text withCategoriesArray:self.searchCategoriesArray];
    }
    else
    {
        NSLog(@"searchButtonContainerHit: %@", theButton);
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.appRootViewController searchButtonHitWithString:theButton.searchLabel.text withCategoriesArray:self.searchCategoriesArray];
        
        
    }
    
}


-(void)loadCategoryButtonsWithString:(NSString *)theCategoriesString
{
    float xOffset = 15;
    float yOffset = self.categoryContainerImageView.frame.origin.y + self.categoryContainerImageView.frame.size.height / 8;
    NSArray *categoriesArray = [theCategoriesString componentsSeparatedByString:@">"];
    self.searchCategoriesArray = [[NSArray alloc] initWithArray:categoriesArray];
    
    for (int i = 0; i < [categoriesArray count]; i++)
    {
        NSString *categoriesString = [[categoriesArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        SearchButtonContainerView *buttonContainerView = [[SearchButtonContainerView alloc] init];
        [buttonContainerView loadWithSearchTerm:categoriesString withClickDelegate:self];
        buttonContainerView.frame = CGRectMake(xOffset, yOffset, [buttonContainerView.searchTerm sizeWithFont:buttonContainerView.searchLabel.font].width + 28, self.categoryContainerImageView.frame.size.height - self.categoryContainerImageView.frame.size.height / 4);
        
        
        [buttonContainerView sizeViewWithFrame];
        buttonContainerView.frame = CGRectMake(buttonContainerView.frame.origin.x, buttonContainerView.frame.origin.y, buttonContainerView.frame.size.width * .85, buttonContainerView.frame.size.height);
        buttonContainerView.exitImageView.alpha = 0;
        xOffset = buttonContainerView.frame.origin.x + buttonContainerView.frame.size.width + 15;
        
        if (xOffset > 290)
        {
            self.categoryContainerView.frame = CGRectMake(self.categoryContainerView.frame.origin.x, self.categoryContainerView.frame.origin.y, self.categoryContainerView.frame.size.width, self.categoryContainerView.frame.size.height * 2);
            self.categoryContainerBottomSeparatorImageView.frame = CGRectMake(self.categoryContainerBottomSeparatorImageView.frame.origin.x, self.categoryContainerBottomSeparatorImageView.frame.origin.y * 2, self.categoryContainerBottomSeparatorImageView.frame.size.width, self.categoryContainerBottomSeparatorImageView.frame.size.height);
            self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + 38, self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height);
            
            xOffset = 15;
            yOffset = self.categoryContainerView.frame.size.height / 2;
            buttonContainerView.frame = CGRectMake(xOffset, yOffset, [buttonContainerView.searchTerm sizeWithFont:buttonContainerView.searchLabel.font].width + 28, self.categoryContainerImageView.frame.size.height - self.categoryContainerImageView.frame.size.height / 4);
            [self.categoryContainerView addSubview:buttonContainerView];
        }
        else
            [self.categoryContainerView addSubview:buttonContainerView];
    }
    
    
}
-(void)commentAddTextShouldBeginEditingWithTextField:(UITextField *)theTextField
{
    self.commentTextField = theTextField;
    NSLog(@"commentAddTextShouldBeginEditing");
    
    [UIView animateWithDuration:.25f animations:^{
        
        self.contentScrollView.contentSize = CGSizeMake(0, self.contentScrollView.contentSize.height * 2);
        
        NSLog(@"self.contentScrollView.contentOffset: %f", self.contentScrollView.contentOffset.y);
        
        [self.contentScrollView setContentOffset:CGPointMake(0,155 + self.contentScrollView.contentOffset.y) animated:YES];
        //        self.contentScrollView.userInteractionEnabled = NO;
        
        self.commentExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentExitButton.backgroundColor = [UIColor clearColor];
        self.commentExitButton.frame = CGRectMake(0,0, self.contentScrollView.frame.size.width, 253);
        [self.commentExitButton addTarget:self action:@selector(commentsViewShouldReset) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.commentExitButton];
        
    } completion:nil];
    
}

-(void)commentsViewShouldReset
{
    [self.commentTextField resignFirstResponder];
    [self.commentExitButton removeFromSuperview];
    [UIView animateWithDuration:.25f animations:^{
        
        [self.contentScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        //        self.contentScrollView.userInteractionEnabled = YES;
        
    } completion:nil];
}

-(void)commentAddTextShouldEndEditing
{
    [self commentsViewShouldReset];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/comments", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", self.commentTextField.text, @"text", nil];
    NSLog(@"params: %@", params);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram  postRequestWithParams:params delegate:self];
    
    
    
}

- (void) loadContentViews
{
    [self.sellerProfileImageView beginAnimations];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.requestedProductObject objectForKey:@"owner_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 9; i++)
    {
        NSString *attributeKeyString = [NSString stringWithFormat:@"attribute_%d", i];
        NSString *attributeValue = [self.requestedProductObject objectForKey:attributeKeyString];
        
        if (![attributeValue isKindOfClass:[NSNull class]])
            if ([attributeValue length] > 0 != NSOrderedSame)
                [attributesArray addObject:attributeValue];
    }
    
    NSMutableString *categoryString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [attributesArray count]; i++)
    {
        [categoryString appendString:[attributesArray objectAtIndex:i]];
        if (i != [attributesArray count] -1)
            [categoryString appendString:@" > "];
    }
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedProductObject objectForKey:@"products_url"] withImageView:self.imageView];
  
    self.descriptionTextView.text = [self.requestedProductObject objectForKey:@"products_description"];
    [self loadCategoryButtonsWithString:categoryString];
    
    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - self.bottomView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    
    [self.view bringSubviewToFront:self.bottomView];
    
    
    if ([[self.requestedProductObject objectForKey:@"is_saved"] boolValue])
        self.saveButton.selected = YES;
    else
        self.saveButton.selected = NO;
    
    [self setViewSpacing];
}

-(void)imageRequestFinished:(UIImageView *)referenceImageView
{
    
    //    if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
    //        [(ISAsynchImageView *)referenceImageView ceaseAnimations];
    
    
}

-(void)loadForEdit
{
    self.isEditable = YES;        
}


-(void)editButtonHit
{
    NSLog(@"editButtonHit");
    
    ProductDetailsViewController *productDetailsViewController = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
    productDetailsViewController.isEdit = YES;
    productDetailsViewController.parentController = self;
    productDetailsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, 320,520);
    [self.navigationController pushViewController:productDetailsViewController animated:YES];
    
    
    [productDetailsViewController loadWithProductObject:self.requestedProductObject withMediaInstagramID:[self.requestedProductObject objectForKey:@"products_instagram_id"]];
    //    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    if ([request.url rangeOfString:@"comments"].length > 0)
    {
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        [dataArray addObject:[NSNull null]];
/*
        self.descriptionContainerView.frame = CGRectMake(self.descriptionContainerView.frame.origin.x, self.descriptionContainerView.frame.origin.y, self.descriptionContainerView.frame.size.width, self.descriptionContainerView.frame.size.height + ([dataArray count] * 47));
        self.commentsTableViewController.view.frame = CGRectMake(0, self.commentsTableViewController.view.frame.origin.y, self.commentsTableViewController.view.frame.size.width, 44 * ([dataArray count]) );
        self.contentScrollView.contentSize = CGSizeMake(0, self.descriptionContainerView.frame.origin.y + self.descriptionContainerView.frame.size.height - 15);
        
        
        self.commentsTableViewController.commentsDataArray = [[NSArray alloc] initWithArray:dataArray];
        [self.commentsTableViewController.tableView reloadData];
  */
        
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *metaDictionary = [result objectForKey:@"meta"];
        if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
            
            if ([(NSString *)[dataDictionary objectForKey:@"id"] compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
                [self loadForEdit];
        }
    }
    else if ([request.url rangeOfString:@"likes"].length > 0)
    {
        if ([request.httpMethod compare:@"POST"] == NSOrderedSame)
        {
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
            [appDelegate.instagram requestWithParams:params delegate:self];
            
            
        }
        else if ([request.httpMethod compare:@"DELETE"] == NSOrderedSame)
        {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
            [appDelegate.instagram requestWithParams:params delegate:self];
            
            
        }
        else
        {
            NSArray *dataArray = [result objectForKey:@"data"];
            self.likesArray = [[NSArray alloc] initWithArray:dataArray];
            self.likesLabel.text = [NSString stringWithFormat:@"%d likes", [dataArray count]];
            
            if ([self likesArrayContainsSelf])
                self.heartImageView.image = [UIImage imageNamed:@"heart_red.png"];
            else
                self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
        }
    }
    
    self.likesLabel.textColor = [UIColor whiteColor];
    self.likesLabel.alpha = 1;
}



-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    //   NSLog(@"theArray: %@", theArray);
    if ([theArray count] > 0)
        self.requestedProductObject = [theArray objectAtIndex:0];
 
    [ViglinkAPIHandler makeViglinkRestCallWithDelegate:self withReferenceURLString:[self.requestedProductObject objectForKey:@"products_external_url"]];
    
    [self loadContentViews];
}


- (void)webControllerBackButtonHit
{
    
}


- (IBAction) saveButtonHit
{
    [SavedItemsAPIHandler makeSavedItemRequestWithDelegate:self withInstagramID:[InstagramUserObject getStoredUserObject].userID withProductID:[self.requestedProductObject objectForKey:@"product_id"]];
    
    [NotificationsAPIHandler createUserSavedNotificationWithProductID:[self.requestedProductObject objectForKey:@"product_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID];
    
    NSString *flurryString = [NSString stringWithFormat:@"User saved"];
    NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self.requestedProductObject objectForKey:@"product_id"], @"product_id", nil];
    [Flurry logEvent:flurryString withParameters:flurryParams];
    
}

-(void)savedItemsCompleted
{
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self withInstagramID:[InstagramUserObject getStoredUserObject].userID];
}


-(IBAction)buyButtonHit
{    
    self.JKProgressView = [JKProgressView presentProgressViewInView:self.view withText:@"Loading..."];

    
    self.isBuying = YES;
    if (self.viglinkString == nil)
        [ViglinkAPIHandler makeViglinkRestCallWithDelegate:self withReferenceURLString:[self.requestedProductObject objectForKey:@"products_external_url"]];
    else
        [AmberAPIHandler makeAmberSupportedSiteCallWithReference:[self.requestedProductObject objectForKey:@"products_external_url"] withResponseDelegate:self];
    
    NSString *flurryString = [NSString stringWithFormat:@"User bought"];
    NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:[self.requestedProductObject objectForKey:@"product_id"], @"product_id", nil];
    [Flurry logEvent:flurryString withParameters:flurryParams];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title compare:@"Wait"] == NSOrderedSame)
    {
        if (buttonIndex == 1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [ProductAPIHandler deleteProductWithProductID:[self.requestedProductObject objectForKey:@"product_id"]];
        }
    }
}

-(void)amberSupportedSiteCallFinishedWithIsSupported:(BOOL)isSupported withExpandedURLString:(NSString *)expandedURLString
{
    NSLog(@"amberSupportedSiteCallFinishedWithIsSupported, isSupported: %d", isSupported);
    
    [self.JKProgressView hideProgressView];
    
    if (isSupported)
    {
        AmberViewController *amberViewController = [[AmberViewController alloc] initWithNibName:@"AmberViewController" bundle:nil];
        amberViewController.referenceImage = self.imageView.image;
        amberViewController.referenceURLString = expandedURLString;//[self.requestedProductObject objectForKey:@"products_external_url"];
        amberViewController.viglinkString = self.viglinkString;
        [self.navigationController pushViewController:amberViewController animated:YES];
        [amberViewController loadView];
        [amberViewController run];
    }
    else
    {
        self.cialBrowserViewController = [[CIALBrowserViewController alloc] init];
        self.cialBrowserViewController.purchasingViewController = self;
        [self.navigationController pushViewController:cialBrowserViewController animated:YES];
        [self.cialBrowserViewController openThisURL:[NSURL URLWithString:self.viglinkString]];
        [self.cialBrowserViewController loadRightBarItem];
        
    }
    
}


-(void)bitlyCallDidRespondWIthShortURLString:(NSString *)shortURLString
{
    
//    NSLog(@"bitlyCallDidRespondWIthShortURLString: %@", shortURLString);
    if (shortURLString != nil)
        self.viglinkString = shortURLString;
    
    if (self.isBuying)
        [AmberAPIHandler makeAmberSupportedSiteCallWithReference:[self.requestedProductObject objectForKey:@"products_external_url"] withResponseDelegate:self];
    
//    NSLog(@"self.viglinkstring: %@", self.viglinkString);

}

-(void)viglinkCallReturned:(NSString *)urlString
{
    self.viglinkString = urlString;
//    NSLog(@"viglinkCallReturned: %@", self.viglinkString);
    [BitlyAPIHandler makeBitlyRequestWithDelegate:self withReferenceURL:self.viglinkString];
    
}





-(IBAction)sizeButtonHit
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL proceed = YES;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            proceed = NO;
    
    if (proceed)
    {
        NSMutableArray *sizesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [sizeQuantityArray count]; i++)
        {
            NSDictionary *obj = [sizeQuantityArray objectAtIndex:i];
            [sizesArray addObject:[obj objectForKey:@"size"]];
        }
        
        self.sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
        self.sizePickerViewViewController.type = 0;
        self.sizePickerViewViewController.itemsArray = [NSMutableArray arrayWithArray:sizesArray];
        
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.autoresizesSubviews = NO;
        self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self.actionSheet addSubview:self.sizePickerViewViewController.view];
        
        [self.actionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
        [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
        
        [self.sizePickerViewViewController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.sizePickerViewViewController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No Size selection necessary"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

-(IBAction)quantityButtonHit
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL isSingleSize = NO;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            isSingleSize = YES;
    
    NSMutableArray *quantityArray = nil;
    
    
    if (isSingleSize)
    {
        quantityArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 1; i <= [[[sizeQuantityArray objectAtIndex:0] objectForKey:@"quantity"] intValue]; i++)
            [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    
    else if (self.sizeSelectedIndex >= 0)
    {
        quantityArray = [NSMutableArray arrayWithCapacity:0];
        int quantity = [[[sizeQuantityArray objectAtIndex:self.sizeSelectedIndex] objectForKey:@"quantity"] intValue];
        for (int i = 1; i <= quantity; i++)
            [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
        
    }
    
    
    
    
    if (quantityArray != nil || isSingleSize)
    {
        
        self.sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
        self.sizePickerViewViewController.type = 1;
        self.sizePickerViewViewController.itemsArray = [NSMutableArray arrayWithArray:quantityArray];
        //[self presentViewController:self.sizePickerViewViewController animated:YES completion:nil];
        
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.autoresizesSubviews = NO;
        self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self.actionSheet addSubview:self.sizePickerViewViewController.view];
        
        [self.actionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
        [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
        
        [self.sizePickerViewViewController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.sizePickerViewViewController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select a size"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

-(void)pickerCancelButtonHit
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)pickerSaveButtonHit
{
    if (self.actionSheet)
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *titleItem = [self.sizePickerViewViewController.itemsArray objectAtIndex:[self.sizePickerViewViewController.thePickerView selectedRowInComponent:0]];
    if (self.sizePickerViewViewController.type == 0)
    {
        [self.sizeButton setTitle:titleItem forState:UIControlStateNormal];
        self.sizeSelectedIndex = [self.sizePickerViewViewController.thePickerView selectedRowInComponent:0];
    }
    else
    {
        if (self.sizeSelectedIndex == -1)
            self.sizeSelectedIndex = 0;
        
        [self.quantityButton setTitle:titleItem forState:UIControlStateNormal];
        
    }
}




-(IBAction)likeButtonHit
{
    
    NSLog(@"likeButtonHit");
    
//    NSLog(@"requestedProductObject: %@", requestedProductObject);
//    [NotificationsAPIHandler createUserLikedNotificationWithProductID:[self.requestedProductObject objectForKey:@"products_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self likesArrayContainsSelf])
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
        [appDelegate.instagram delRequestWithParams:params delegate:self];
    }
    else
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
        [appDelegate.instagram postRequestWithParams:params delegate:self];
    }
    
}

-(BOOL)likesArrayContainsSelf
{
    BOOL sameID = NO;
    for (int i = 0; i < [self.likesArray count]; i++)
    {
        NSDictionary *likeDictionary = [self.likesArray objectAtIndex:i];
        
        NSString *likeID = [likeDictionary objectForKey:@"id"];
        
        if ([likeID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
            sameID = YES;
        
    }
    
    return sameID;
}



- (IBAction) profileButtonHit
{
    if (self.requestedProductObject != nil)
        if ([self.requestedProductObject objectForKey:@"owner_instagram_id"] != nil)
        {
            ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            profileViewController.profileInstagramID = [self.requestedProductObject objectForKey:@"owner_instagram_id"];
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
}


-(void)previewButtonHitWithProductCreateObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    ProductPreviewViewController *productPreviewViewController = [[ProductPreviewViewController alloc] initWithNibName:@"ProductPreviewViewController" bundle:nil];
    productPreviewViewController.view.frame = CGRectMake(productPreviewViewController.view.frame.origin.x, productPreviewViewController.view.frame.origin.y, productPreviewViewController.view.frame.size.width, productPreviewViewController.view.frame.size.height);
    productPreviewViewController.parentController = self;
    productPreviewViewController.view.frame = productPreviewViewController.view.frame;
    [self.navigationController pushViewController:productPreviewViewController animated:YES];
    [productPreviewViewController loadWithProductCreateObject:productCreateContainerObject];
    
    
}


- (void)previewDoneButtonHit:(ProductCreateContainerObject *)theCreateObject
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController  *rootVC = delegate.appRootViewController;
    
    
    if (theCreateObject.mainObject.editingReferenceID != nil)
    {
    }
    else
    {
        self.JKProgressView = [JKProgressView presentProgressViewInView:self.view withText:@"Creating Product..."];
        [CreateProductAPIHandler createProductContainerObject:self withProductCreateObject:theCreateObject];
    }
    
}


-(void)editProductComplete
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController  *rootVC = delegate.appRootViewController;
        
    [self.JKProgressView hideProgressView];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Product Edited!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"That's great"
                                              otherButtonTitles:nil];
    [alertView show];
    
    
}

- (void) openActionSheet {
    self.actionSheetHandlingViewController = self;
    [self beginActionSheet];
}
-(void)openActionSheetFromCallerController:(UIViewController *)callerController
{
    self.actionSheetHandlingViewController = callerController;
    [self beginActionSheet];
}

- (void) beginActionSheet {
    
    

    if (self.isEditable)
    {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Edit", @"Delete", nil];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect:CGRectMake(0,self.actionSheetHandlingViewController.view.frame.size.height, self.actionSheetHandlingViewController.view.frame.size.width,self.actionSheetHandlingViewController.view.frame.size.width) inView:self.actionSheetHandlingViewController.view animated:YES];
    }
    else
    {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Flag", nil];
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect:CGRectMake(0,self.actionSheetHandlingViewController.view.frame.size.height, self.actionSheetHandlingViewController.view.frame.size.width,self.actionSheetHandlingViewController.view.frame.size.width) inView:self.actionSheetHandlingViewController.view animated:YES];
    }
}


-(void)willPresentActionSheet:(UIActionSheet *)theActionSheet
{
    for (UIButton *button in theActionSheet.subviews)
        if ([button isKindOfClass:[UIButton class]])
        {
            if ([[button titleForState:UIControlStateNormal] compare:@"Flag"] == NSOrderedSame)
                button.titleLabel.textColor = [UIColor redColor];
            else if ([[button titleForState:UIControlStateNormal] compare:@"Delete"] == NSOrderedSame)
                button.titleLabel.textColor = [UIColor redColor];
        }
}


- (void) actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    NSLog(@"vigLinkString: %@", self.viglinkString);
    NSString *buttonTitle = [theActionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Edit"]) {
        [self editButtonHit];
    }
    else if ([buttonTitle isEqualToString:@"Delete"])
    {
        NSLog(@"delete");
        
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Wait"
                                                            message:@"Are you sure you want to delete?"
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES", nil];
        [alertView show];
        
        
    }
    else if ([buttonTitle isEqualToString:@"Flag"]) {
        
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        UIActionSheet *flagActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Inappropriate", @"Incorrect Link", @"Other", nil];
        flagActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [flagActionSheet showFromRect:CGRectMake(0,self.actionSheetHandlingViewController.view.frame.size.height, self.actionSheetHandlingViewController.view.frame.size.width,self.actionSheetHandlingViewController.view.frame.size.width) inView:self.actionSheetHandlingViewController.view animated:YES];
    }
    
    else if ([buttonTitle isEqualToString:@"Inappropriate"] || [buttonTitle isEqualToString:@"Incorrect Link"] || [buttonTitle isEqualToString:@"Other"]) {
        
        NSString *userID = [InstagramUserObject getStoredUserObject].userID;
        [FlagManagerAPIHandler makeFlagDeclarationRequestComplaint:buttonTitle andProductID:self.requestingProductID userID: userID delegate:self];
    }
    
    else if ([buttonTitle compare:@"Facebook"] == NSOrderedSame)
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
                    [NotificationsAPIHandler createUserSocialNotificationWithProductID:[self.requestedProductObject objectForKey:@"product_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID withSocialType:@"facebook"];
                    break;
            }};
        
        
        
        
        //UIImage *photoImage = self.imageView.image;
        
        NSString *postText = [NSString stringWithFormat:@"%@ via %@", [self.requestedProductObject objectForKey:@"products_description"], @"@shopsy"];
        [facebookController setInitialText:postText];
        //[facebookController addImage:photoImage];
        [facebookController addURL:[NSURL URLWithString:self.viglinkString]];
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
                    [NotificationsAPIHandler createUserSocialNotificationWithProductID:[self.requestedProductObject objectForKey:@"product_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID withSocialType:@"twitter"];
                    break;
            }};
        
        
        
        
        UIImage *photoImage = self.imageView.image;
        
        
        NSString *postText = [NSString stringWithFormat:@"%@ via %@", [self.requestedProductObject objectForKey:@"products_description"], @"@shopsyapp"];
        [tweetController setInitialText:postText];
        [tweetController addImage:photoImage];
        [tweetController addURL:[NSURL URLWithString:self.viglinkString]];
        [tweetController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:tweetController animated:YES completion:nil];
        
    }
    
    
    
}

- (void) showComplaintReceivedAlert:(NSString *) message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    
    [alertView show];
}



-(void)twitterShareCancelButtonHit
{
    
}

-(void)twitterShareGoButtonHit
{
    
}






-(IBAction)buyButtonHitBAK
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL isSingleSize = NO;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            isSingleSize = YES;
    
    
    if (!isSingleSize &&  [[self.sizeButton titleForState:UIControlStateNormal] compare:@"Size"] == NSOrderedSame)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select a size and or quantity"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
        NSDictionary *productCategoryObject = [sizeQuantityArray objectAtIndex:self.sizeSelectedIndex];
        

        
    }
    
}




@end
