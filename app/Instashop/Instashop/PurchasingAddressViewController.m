//
//  PurchasingAddressViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingAddressViewController.h"
#import "SellersAPIHandler.h"
#import "PostmasterAPIHandler.h"
#import "InstagramUserObject.h"
#import "SellersAPIHandler.h"
#import "PostmasterAPIHandler.h"
#import "MBProgressHUD.h"
#import "STPCard.h"
#import "StripeAuthenticationHandler.h"
#import "ProductAPIHandler.h"
#import "PurchasingCompleteViewController.h"
@interface PurchasingAddressViewController ()

@property (nonatomic, retain) NSDictionary *requestedProductObject;


@end

@implementation PurchasingAddressViewController

@synthesize contentScrollView;

@synthesize productDetailsPlacementView;
@synthesize productDetailsContentView;
@synthesize doneButtonDelegate;
@synthesize shippingCompleteDelegate;
@synthesize productImageView;
@synthesize productTitleLabel;
@synthesize sizeValueLabel;
@synthesize sizeTextLabel;
@synthesize quantityValueLabel;
@synthesize quantityTextLabel;
@synthesize priceValueLabel;
@synthesize priceTextLabel;
@synthesize nameTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;
@synthesize checkRatesButton;
@synthesize doneButton;
@synthesize productBuyButtonLabel;
@synthesize productCategoryDictionary;
@synthesize sellerDictionary;
@synthesize upsRateDictionary;
@synthesize fedexRateDictionary;

@synthesize creditCardNumberTextField;
@synthesize expirationTextField;
@synthesize ccvTextField;
@synthesize requestedPostmasterDictionary;


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
    
    self.sizeTextLabel.text = @"Size";
    self.priceTextLabel.text = @"Price";
    self.quantityTextLabel.text = @"Quantity";
    
    self.sizeTextLabel.font = [UIFont systemFontOfSize:10];
    self.priceTextLabel.font = self.sizeTextLabel.font;
    self.quantityTextLabel.font = self.sizeTextLabel.font;
    
    self.sizeValueLabel.font = [UIFont systemFontOfSize:16];
    self.priceValueLabel.font = self.sizeValueLabel.font;
    self.quantityValueLabel.font = self.sizeValueLabel.font;

    
    [self.view addSubview:self.productDetailsContentView];
    self.productDetailsContentView.frame = CGRectMake(self.productDetailsPlacementView.frame.origin.x,self.productDetailsPlacementView.frame.origin.y,self.productDetailsPlacementView.frame.size.width, self.productDetailsPlacementView.frame.size.height);
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;

    self.contentScrollView.contentSize = CGSizeMake(0, self.doneButton.frame.origin.y + self.doneButton.frame.size.height + 12);
    
}


-(void)loadWithSizeSelection:(NSString *)sizeSelection withQuantitySelection:(NSString *)quantitySelection withProductImage:(UIImage *)productImage
{
    NSLog(@"loadWithSizeSelection, sizeSelection: %@", sizeSelection);
    
    BOOL showSize = YES;
    if (sizeSelection == nil)
        showSize = NO;
    else if ([sizeSelection compare:@"(null)"] == NSOrderedSame)
        showSize = NO;
    else if ([sizeSelection compare:@"Size"] == NSOrderedSame)
        showSize = NO;

    if (showSize)
        self.sizeValueLabel.text = sizeSelection;
    else
    {
        self.sizeTextLabel.text = @"";
        self.sizeValueLabel.text = @"";
    }

    
    self.quantityValueLabel.text = quantitySelection;
    self.productImageView.image = productImage;
    
    NSLog(@"self.productImageView: %@", self.productImageView);
}

-(void)loadWithRequestedProductObject:(NSDictionary *)theProductObject
{
    self.requestedProductObject = [NSDictionary dictionaryWithDictionary:theProductObject];
    
    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    self.priceValueLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
    self.productTitleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
        
    self.productBuyButtonLabel.text = [NSString stringWithFormat:@"Buy - %@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.quantityValueLabel.text floatValue] * [[self.requestedProductObject objectForKey:@"products_price"] floatValue]]]];
    
    [SellersAPIHandler makeGetSellersRequestWithDelegate:self withSellerInstagramID:[self.requestedProductObject objectForKey:@"owner_instagram_id"]];
}



-(void)sellersRequestFinishedWithResponseObject:(NSArray *)responseArray
{
    if ([responseArray count] > 0)
        self.sellerDictionary = [[NSDictionary alloc] initWithDictionary:[responseArray objectAtIndex:0]];
}


-(IBAction)doneButtonHit
{
    [self.doneButtonDelegate doneButtonHitWithAddressVC:self];
}



-(IBAction)buyButtonHit
{
    
    [self.addressTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
    [self.stateTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    [self.creditCardNumberTextField resignFirstResponder];
    [self.expirationTextField resignFirstResponder];
    [self.ccvTextField resignFirstResponder];
    
    if (self.upsRateDictionary == nil && self.fedexRateDictionary == nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Getting Rates";
        [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"UPS"];
        [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"FEDEX"];
    }
}

-(void)ratesCallReturnedWithDictionary:(NSDictionary *)returnDict
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (returnDict != nil)
    {
        if ([(NSString *)[returnDict objectForKey:@"carrier"] compare:@"UPS"] == NSOrderedSame)
            self.upsRateDictionary = [[NSDictionary alloc] initWithDictionary:returnDict];
        else if ([(NSString *)[returnDict objectForKey:@"carrier"] compare:@"FEDEX"] == NSOrderedSame)
            self.fedexRateDictionary = [[NSDictionary alloc] initWithDictionary:returnDict];
    }
    
    if (self.upsRateDictionary != nil && self.fedexRateDictionary != nil)
    {
        
        NSString *upsString = [NSString stringWithFormat:@"%@ %@ %@", [self.upsRateDictionary objectForKey:@"carrier"], [self.upsRateDictionary objectForKey:@"charge"], [self.upsRateDictionary objectForKey:@"service"]];
        NSString *fedexString = [NSString stringWithFormat:@"%@ %@ %@", [self.fedexRateDictionary objectForKey:@"carrier"], [self.fedexRateDictionary objectForKey:@"charge"], [self.fedexRateDictionary objectForKey:@"service"]];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Rates"
                                      delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:upsString, fedexString, nil];
        [actionSheet showInView:self.view];
        
        
    }
    
}

-(void)ratesCallDidFail
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure all fields are filled out correctly"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index: %d", buttonIndex);
    
    
    NSMutableDictionary *theSellerDict = [NSMutableDictionary dictionaryWithDictionary:sellerDictionary];
    [theSellerDict setObject:[sellerDictionary objectForKey:@"instagram_id"] forKey:@"seller_instagram_id"];
    [theSellerDict removeObjectForKey:@"instagram_id"];
    
    NSMutableDictionary *theBuyerDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [theBuyerDict setObject:self.stateTextField.text forKey:@"buyer_state"];
    [theBuyerDict setObject:self.zipTextField.text forKey:@"buyer_zip"];
    [theBuyerDict setObject:self.addressTextField.text forKey:@"buyer_address"];
    [theBuyerDict setObject:self.nameTextField.text forKey:@"buyer_name"];
    [theBuyerDict setObject:self.phoneTextField.text forKey:@"buyer_phone"];
    [theBuyerDict setObject:self.cityTextField.text forKey:@"buyer_city"];
    [theBuyerDict setObject:[InstagramUserObject getStoredUserObject].userID forKey:@"buyer_instagram_id"];
    
    NSMutableDictionary *packageDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [packageDictionary setObject:@"1.5" forKey:@"package_weight"];
    [packageDictionary setObject:@"10" forKey:@"package_length"];
    [packageDictionary setObject:@"6" forKey:@"package_width"];
    [packageDictionary setObject:@"8" forKey:@"package_height"];
    
    
    switch (buttonIndex) {
        case 0:
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Postmaster Call";
            [PostmasterAPIHandler makePostmasterShipRequestCallWithDelegate:self withFromDictionary:theSellerDict withToDictionary:theBuyerDict shippingDictionary:self.upsRateDictionary withPackageDictionary:packageDictionary];
            break;
        case 1:
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Postmaster Call";
            [PostmasterAPIHandler makePostmasterShipRequestCallWithDelegate:self withFromDictionary:theSellerDict withToDictionary:theBuyerDict shippingDictionary:self.fedexRateDictionary withPackageDictionary:packageDictionary];
            break;
        default:
            self.upsRateDictionary = nil;
            self.fedexRateDictionary = nil;
            
            break;
    }
    
}

-(void)postmasterShipRequestRespondedWithDictionary:(NSDictionary *)theDict
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];    
    [self doStripePurchaseWithPostMasterDictionary:theDict];
    
}

-(void)postmasterShipCallFailed
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure all fields are filled out correctly"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
}

-(void)doStripePurchaseWithPostMasterDictionary:(NSDictionary *)thePostmasterDictionary
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO].detailsLabelText = @"Stripe Call";
    self.requestedPostmasterDictionary = [NSDictionary dictionaryWithDictionary:thePostmasterDictionary];
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
    
    NSString *zencartProductID = [NSString stringWithFormat:@"product_id: %@", [self.requestedProductObject objectForKey:@"product_id"]];
    [StripeAuthenticationHandler buyItemWithToken:stripeToken withPurchaseAmount:priceString withDescription:zencartProductID withDelegate:self];
    
}


-(void)buySuccessfulWithDictionary:(id)theDict
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO].detailsLabelText = @"Instashop Call";
    [ProductAPIHandler productPurchasedWithDelegate:self withStripeDictionary:theDict withProductObject:self.requestedProductObject withProductCategoryObjectID:[productCategoryDictionary objectForKey:@"id"] withPostmasterDictionary:self.requestedPostmasterDictionary];
    
}

-(void)productPurchaceSuccessful
{
    NSLog(@"productPurchaceSuccessful productPurchaceSuccessful");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSArray *array = [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSLog(@"array: %@", array);
    
    [PurchasingCompleteViewController presentWithProductObject:nil];
    
}





@end
