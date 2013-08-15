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
#import "STPCard.h"
#import "StripeAuthenticationHandler.h"
#import "ProductAPIHandler.h"
#import "PurchasingAddressViewController.h"
#import "SellersAPIHandler.h"
#import "SizePickerViewViewController.h"

@interface PurchasingViewController ()

@property (nonatomic, retain) NSDictionary *requestedProductObject;

@end

@implementation PurchasingViewController

@synthesize heartImageView;
@synthesize sizePickerViewViewController;
@synthesize requestingProductID;
@synthesize requestedPostmasterDictionary;
@synthesize parentController;
@synthesize contentScrollView;
@synthesize categoryLabel;
@synthesize descriptionContainerView;
@synthesize requestedProductObject;
@synthesize imageView, titleLabel, sellerLabel, likesLabel, descriptionTextView, priceLabel, numberAvailableLabel, sellerProfileImageView;
@synthesize bottomView;
@synthesize sizeSelectedIndex;
@synthesize purchaseButton;
@synthesize likesArray;
@synthesize imageLoadingIndicatorView;

@synthesize actionSheet;
@synthesize quantityButton;
@synthesize sizeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
  
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.contentScrollView.frame = CGRectMake(0,0, screenWidth, screenHeight - 50);
    self.contentScrollView.contentSize = CGSizeMake(0, self.descriptionContainerView.frame.origin.y + self.descriptionContainerView.frame.size.height);
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentScrollView];
    
    
    
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    
    self.bottomView.frame = CGRectMake(0, screenHeight - self.bottomView.frame.size.height, 320, self.bottomView.frame.size.height);

    NSLog(@"view: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"content view: %@", NSStringFromCGRect(self.contentScrollView.frame));
    NSLog(@"content view scroll area: %@", NSStringFromCGSize(self.contentScrollView.contentSize));
    NSLog(@"bottom view: %@", NSStringFromCGRect(self.bottomView.frame));
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self];
    
    self.sizeSelectedIndex = -1;
    
    self.descriptionTextView.text = @"";
    
    [self.view bringSubviewToFront:self.purchaseButton];
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
    
    

    
    self.imageLoadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.imageLoadingIndicatorView.frame = self.sellerProfileImageView.frame;
    [self.contentScrollView addSubview:self.imageLoadingIndicatorView];
    
    [self.imageLoadingIndicatorView startAnimating];
    
}


- (void) loadContentViews
{
    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
        
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
    self.titleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [self.requestedProductObject objectForKey:@"products_description"];
    self.numberAvailableLabel.text = [NSString stringWithFormat:@"%d left", [[self.requestedProductObject objectForKey:@"products_quantity"] intValue]];
    self.priceLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
    self.categoryLabel.text = categoryString;
    
    
    
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL proceed = YES;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            self.sizeButton.alpha = 0;

    
    
}

-(void)imageRequestFinished:(UIImageView *)referenceImageView
{
    NSLog(@"imageRequestFinished imageRequestFinished");
    if (referenceImageView == self.sellerProfileImageView)
    {
        [self.imageLoadingIndicatorView stopAnimating];
        [self.imageLoadingIndicatorView removeFromSuperview];
    }
}

- (void)request:(IGRequest *)request didLoad:(id)result {
        
    if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *metaDictionary = [result objectForKey:@"meta"];
        if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
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
}



-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    if ([theArray count] > 0)
        self.requestedProductObject = [theArray objectAtIndex:0];
    
    [self loadContentViews];
}


-(IBAction)buyButtonHit
{
    if (self.sizeSelectedIndex == -1 || [[self.quantityButton titleForState:UIControlStateNormal] compare:@"Quantity"] == NSOrderedSame)
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
        
        PurchasingAddressViewController *purchasingAddressViewController = [[PurchasingAddressViewController alloc] initWithNibName:@"PurchasingAddressViewController" bundle:nil];
        purchasingAddressViewController.productCategoryDictionary = productCategoryObject;
        purchasingAddressViewController.shippingCompleteDelegate = self;
        [self.navigationController pushViewController:purchasingAddressViewController animated:YES];
        [purchasingAddressViewController loadWithSizeSelection:[self.sizeButton titleForState:UIControlStateNormal] withQuantitySelection:[self.quantityButton titleForState:UIControlStateNormal] withProductImage:self.imageView.image];
        [purchasingAddressViewController loadWithRequestedProductObject:self.requestedProductObject];
        
    }
    
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


-(IBAction)backButtonHit
{
    [self.parentController purchasingViewControllerBackButtonHitWithVC:self];
    
}




@end
