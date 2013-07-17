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
@synthesize requestedProductObject;
@synthesize imageView, titleLabel, sellerLabel, descriptionTextView, priceLabel, numberAvailableLabel, sellerProfileImageView;
@synthesize bottomView;
@synthesize sizeSelectedIndex;
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
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self];
    
    self.sizeSelectedIndex = -1;
    
}

- (void) loadContentViews
{
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
    
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
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
        
        PurchasingAddressViewController *purchasingAddressViewController = [[PurchasingAddressViewController alloc] initWithNibName:@"PurchasingAddressViewController" bundle:nil];
        purchasingAddressViewController.shippingCompleteDelegate = self;
//        purchasingAddressViewController.sellerDictionary = [[NSDictionary alloc] initWithDictionary:[responseArray objectAtIndex:0]];
//        [self.navigationController presentViewController:purchasingAddressViewController animated:YES completion:nil];
        [self.navigationController pushViewController:purchasingAddressViewController animated:YES];
        
        [purchasingAddressViewController loadWithSizeSelection:[self.sizeButton titleForState:UIControlStateNormal] withQuantitySelection:[self.quantityButton titleForState:UIControlStateNormal] withProductImage:self.imageView.image];
        [purchasingAddressViewController loadWithRequestedProductObject:self.requestedProductObject];
 
    }

}





-(void) postmasterShipCompleteWithPostmasterDictionary:(NSDictionary *)thePostmasterDictionary
{
    self.requestedPostmasterDictionary = [thePostmasterDictionary retain];
    STPCard *stripeCard = [[STPCard alloc] init];
    stripeCard.number = @"4242424242424242";
    stripeCard.expMonth = 05;
    stripeCard.expYear = 15;
    stripeCard.cvc = @"123";
    stripeCard.name = @"alchemy50";
    stripeCard.addressLine1 = @"20 Jay Street #934";
    stripeCard.addressZip = @"11201";
    stripeCard.addressCity = @"Brooklyn";
    stripeCard.addressState = @"NY";
    stripeCard.addressCountry = @"KINGS";
    
    [StripeAuthenticationHandler createTokenWithCard:stripeCard withDelegate:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)doBuy
{
    NSString *stripeToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeToken"];
    
    float val = [[self.requestedProductObject objectForKey:@"products_price"] floatValue];
    
    val = val * 100;
    int intVal = [[NSNumber numberWithFloat:val] integerValue];
    NSString *priceString = [NSString stringWithFormat:@"%d", intVal];
    
    NSString *zencartProductID = [NSString stringWithFormat:@"product_id: %@", [requestedProductObject objectForKey:@"product_id"]];
    [StripeAuthenticationHandler buyItemWithToken:stripeToken withPurchaseAmount:priceString withDescription:zencartProductID withDelegate:self];
    
}


-(void)buySuccessfulWithDictionary:(id)theDict
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    [ProductAPIHandler productPurchasedWithDelegate:self withStripeDictionary:theDict withProductObject:self.requestedProductObject withProductCategoryObjectID:[[sizeQuantityArray objectAtIndex:self.sizeSelectedIndex] objectForKey:@"id"] withPostmasterDictionary:self.requestedPostmasterDictionary];
    
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
    NSLog(@"backButtonHit");
}




@end
