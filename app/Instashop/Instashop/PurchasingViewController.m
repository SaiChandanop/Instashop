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
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.contentScrollView.frame = CGRectMake(0,0,320, 520);
    self.contentScrollView.contentSize = CGSizeMake(0, self.descriptionContainerView.frame.origin.y + self.descriptionContainerView.frame.size.height + 75);
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    
    
    
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self];
    
    self.sizeSelectedIndex = -1;
    
    self.descriptionTextView.text = @"";
    
    [self.view bringSubviewToFront:self.purchaseButton];
    
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.height) forBarMetrics:UIBarMetricsDefault];
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;
}


- (void) loadContentViews
{
    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedProductObject objectForKey:@"products_url"] withImageView:self.imageView];
    
    self.titleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [self.requestedProductObject objectForKey:@"products_description"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.requestedProductObject objectForKey:@"owner_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    self.numberAvailableLabel.text = [NSString stringWithFormat:@"%d left", [[self.requestedProductObject objectForKey:@"products_quantity"] intValue]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    self.priceLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
    
    //    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
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
    
    self.categoryLabel.text = categoryString;
    
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"request.url: %@", request.url);
    
    if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *metaDictionary = [result objectForKey:@"meta"];
        if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            NSLog(@"data dictionary: %@", dataDictionary);
            self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
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


-(void)pickerCancelButtonHit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)pickerSaveButtonHit
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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




-(IBAction)sizeButtonHit
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL proceed = YES;
    if ([sizeQuantityArray count] == 1)
        if ([[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"NIL"] == NSOrderedSame)
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
        self.sizePickerViewViewController.itemsArray = [NSArray arrayWithArray:sizesArray];
        [self presentViewController:self.sizePickerViewViewController animated:YES completion:nil];
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
        if ([[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"NIL"] == NSOrderedSame)
            isSingleSize = YES;
    
    NSMutableArray *quantityArray = nil;
    
    
    if (isSingleSize)
        quantityArray = [NSArray arrayWithObject:[[sizeQuantityArray objectAtIndex:0] objectForKey:@"quantity"]];
    else if (self.sizeSelectedIndex >= 0)
    {
        quantityArray = [NSMutableArray arrayWithCapacity:0];
        int quantity = [[[sizeQuantityArray objectAtIndex:self.sizeSelectedIndex] objectForKey:@"quantity"] intValue];
        for (int i = 1; i <= quantity; i++)
            [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
        
    }
    
    if (quantityArray != nil)
    {
        self.sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
        self.sizePickerViewViewController.type = 1;
        self.sizePickerViewViewController.itemsArray = [NSArray arrayWithArray:quantityArray];
        [self presentViewController:self.sizePickerViewViewController animated:YES completion:nil];
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


-(IBAction)backButtonHit
{
    [self.parentController purchasingViewControllerBackButtonHitWithVC:self];
    
}




@end
