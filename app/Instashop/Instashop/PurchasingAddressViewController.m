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

@synthesize keyboardControls;
@synthesize productDetailsPlacementView;
@synthesize productDetailsContentView;
@synthesize purchaseDetailsContentView;
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
@synthesize emailTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize dummyTextField;
@synthesize phoneTextField;
@synthesize checkRatesButton;
@synthesize doneButton;
@synthesize productBuyButtonLabel;
@synthesize productCategoryDictionary;
@synthesize sellerDictionary;
@synthesize upsRateDictionary;
@synthesize fedexRateDictionary;
@synthesize creditCardContainerView;
@synthesize requestedPostmasterDictionary;
@synthesize stpCreditCardNumberTextField;


@synthesize nameView;
@synthesize emailView;
@synthesize phoneView;
@synthesize addressView;
@synthesize cityStateView;
@synthesize zipView;



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
    
    self.dummyTextField = [[UITextField alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.contentScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.sizeTextLabel.text = @"Size";
    self.priceTextLabel.text = @"Price";
    self.quantityTextLabel.text = @"Quantity";
    
    self.sizeTextLabel.font = [UIFont systemFontOfSize:10];
    self.priceTextLabel.font = self.sizeTextLabel.font;
    self.quantityTextLabel.font = self.sizeTextLabel.font;
    
    self.sizeValueLabel.font = [UIFont systemFontOfSize:16];
    self.priceValueLabel.font = self.sizeValueLabel.font;
    self.quantityValueLabel.font = self.sizeValueLabel.font;
    
    //self.nameView
    
    
    [self.view addSubview:self.productDetailsContentView];
    self.productDetailsContentView.frame = CGRectMake(self.productDetailsPlacementView.frame.origin.x,self.productDetailsPlacementView.frame.origin.y,self.productDetailsPlacementView.frame.size.width, self.productDetailsPlacementView.frame.size.height);
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarShopsyLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.doneButton.frame.origin.y + self.doneButton.frame.size.height + 66);
    
    
    self.stpCreditCardNumberTextField = [[PKView alloc] initWithFrame:CGRectMake(self.creditCardContainerView.frame.origin.x+17, self.creditCardContainerView.frame.origin.y + 11.5, self.creditCardContainerView.frame.size.width, self.creditCardContainerView.frame.size.height)];
    [self.purchaseDetailsContentView addSubview:self.stpCreditCardNumberTextField];
    
    [self populateDummy];
    
    
    self.nameView.separatorImageView.alpha = 0;
    self.emailView.separatorImageView.alpha = 0;
    self.phoneView.separatorImageView.alpha = 0;
    self.addressView.separatorImageView.alpha = 0;
    self.cityStateView.separatorImageView.alpha = 0;
    self.zipView.separatorImageView.alpha = 0;
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
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
        //        self.sizeTextLabel.text = @"Size";
        self.sizeValueLabel.text = @"N/A";
    }
    
    
    self.quantityValueLabel.text = quantitySelection;
    self.productImageView.image = productImage;
    
    NSLog(@"self.productImageView: %@", self.productImageView);
    
    
    
}

-(void)loadWithRequestedProductObject:(NSDictionary *)theProductObject
{
    self.requestedProductObject = [NSDictionary dictionaryWithDictionary:theProductObject];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    self.priceValueLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
    self.productTitleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
    
    NSString *buyString = [NSString stringWithFormat:@"Buy - %@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.quantityValueLabel.text floatValue] * [[self.requestedProductObject objectForKey:@"products_price"] floatValue]]]];
    [self.doneButton setTitle:buyString forState:UIControlStateNormal];
    
    [SellersAPIHandler makeGetSellersRequestWithDelegate:self withSellerInstagramID:[self.requestedProductObject objectForKey:@"owner_instagram_id"]];
    
    
    
    
}



-(void)sellersRequestFinishedWithResponseObject:(NSArray *)responseArray
{
    if ([responseArray count] > 0)
        self.sellerDictionary = [[NSDictionary alloc] initWithDictionary:[responseArray objectAtIndex:0]];
}


-(IBAction)doneButtonHit
{
}



-(IBAction)buyButtonHit
{
    
    NSMutableArray *missingFieldsArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.stpCreditCardNumberTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
    [self.stateTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    
    if ([self.nameTextField.text length] == 0)
        [missingFieldsArray addObject:@"Name"];
    
    if ([self.addressTextField.text length] == 0)
        [missingFieldsArray addObject:@"Address"];
    
    if ([self.cityTextField.text length] == 0)
        [missingFieldsArray addObject:@"City"];
    
    if ([self.zipTextField.text length] == 0)
        [missingFieldsArray addObject:@"Zip"];
    
    if ([self.stateTextField.text length] == 0)
        [missingFieldsArray addObject:@"State"];
    
    if ([self.emailTextField.text length] == 0)
        [missingFieldsArray addObject:@"Email"];
    
    
    if ([[self.stpCreditCardNumberTextField.cardNumber string] length] == 0)
        [missingFieldsArray addObject:@"Card Number"];

    if ([[self.stpCreditCardNumberTextField.cardExpiry formattedString] length] == 0)
        [missingFieldsArray addObject:@"Expiration"];
    
    if ([[self.stpCreditCardNumberTextField.cardCVC string] length] == 0)
        [missingFieldsArray addObject:@"CVC"];
    
    if ([missingFieldsArray count] > 0)
    {
        NSString *multipleOne = @"fields";
        NSString *multipleTwo = @"are";
        
        if ([missingFieldsArray count] == 1)
        {
            multipleOne = @"field";
            multipleTwo = @"is";
        }
        
        NSMutableString *fieldsString = [NSMutableString stringWithCapacity:0];
        
        for (int i = 0; i < [missingFieldsArray count]; i++)
        {
            [fieldsString appendString:[missingFieldsArray objectAtIndex:i]];
            
            if (i < [missingFieldsArray count] - 1)
                [fieldsString appendString:@", "];
             
        }
        
        NSString *messageString = [NSString stringWithFormat:@"Please ensure the following %@ %@ set: %@", multipleOne, multipleTwo, fieldsString];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:messageString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        
    }
    
    
    else
    {

    
        [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:@"emailTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:nameTextField.text forKey:@"nameTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:addressTextField.text forKey:@"addressTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:cityTextField.text forKey:@"cityTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:zipTextField.text forKey:@"zipTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:phoneTextField.text forKey:@"phoneTextField"];
        [[NSUserDefaults standardUserDefaults] setObject:stateTextField.text forKey:@"stateTextField"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.stpCreditCardNumberTextField.cardNumber string] forKey:@"cardNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.stpCreditCardNumberTextField.cardExpiry formattedString] forKey:@"cardExpiry"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.stpCreditCardNumberTextField.cardCVC string] forKey:@"cardCVC"];
    
        
        
        
        
        
        
        
        //[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        
        
        
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
        
        NSMutableDictionary *shippingDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [shippingDictionary setObject:@"UPS" forKey:@"carrier"];
        [shippingDictionary setObject:@"GROUND" forKey:@"service"];
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Postmaster Call";
        [PostmasterAPIHandler makePostmasterShipRequestCallWithDelegate:self withFromDictionary:theSellerDict withToDictionary:theBuyerDict shippingDictionary:shippingDictionary withPackageDictionary:packageDictionary];
        
        
        /*
         if (self.upsRateDictionary == nil && self.fedexRateDictionary == nil)
         {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Getting Rates";
         [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"UPS"];
         [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"FEDEX"];
         }
         */
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
    /*    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Please ensure all fields are filled out correctly"
     delegate:nil
     cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     
     [alertView show];
     */
}

-(void)doStripePurchaseWithPostMasterDictionary:(NSDictionary *)thePostmasterDictionary
{
    NSLog(@"doStripePurchaseWithPostMasterDictionary: %@", thePostmasterDictionary);
    
    
    /*
     
     "actual_shipping_cost" = 1211;
     "buyer_city" = Weston;
     "buyer_company" = "test buyer company";
     "buyer_country" = US;
     "buyer_line1" = "5 Tall Pines Dr";
     "buyer_name" = "Josh Klobe";
     "buyer_phone_no" = "212-221-1212";
     "buyer_residential" = 1;
     "buyer_state" = CT;
     "buyer_zip_code" = 06883;
     "postmaster_label_url" = "/v1/label/AMIfv94NDddkRFGfmOJdP-BilJFkTk_TQ7yX9OJgoAp5iuoK1vkri6CE6N9f1_GDbO_gkaAIrHDNWp7VGk75G6c7MQnhnS89g6kuxxS1Ibu-G8YaKlN8ivjCJVQgsrxOg0te1oOHZcWnJZnti-7d5ko9kLdaB08roexedNHrzA6ybcy8QDuw4RQ";
     "postmaster_shipment_id" = 6264089542131712;
     "tracking_id" = 1Z8V81310399240955;
     
     */
    
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO].detailsLabelText = @"Stripe Call";
    self.requestedPostmasterDictionary = [NSDictionary dictionaryWithDictionary:thePostmasterDictionary];
    STPCard *stripeCard = [[STPCard alloc] init];
    stripeCard.number = [self.stpCreditCardNumberTextField.cardNumber string];
    stripeCard.expMonth = [self.stpCreditCardNumberTextField.cardExpiry month];
    stripeCard.expYear = [self.stpCreditCardNumberTextField.cardExpiry year];
    stripeCard.cvc = [self.stpCreditCardNumberTextField.cardCVC string];
    stripeCard.name = self.nameTextField.text;
    stripeCard.addressLine1 = self.addressTextField.text;
    stripeCard.addressZip = self.zipTextField.text;
    stripeCard.addressCity = self.cityTextField.text;
    stripeCard.addressState = self.stateTextField.text;
    //    stripeCard.addressCountry = @"KINGS";
    
    [StripeAuthenticationHandler createTokenWithCard:stripeCard withDelegate:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)tokenCreatedWithDictionary:(NSDictionary *)dict
{
    
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"id"] forKey:@"StripeToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSString *stripeToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeToken"];
    
    float val = [[self.requestedProductObject objectForKey:@"products_price"] floatValue];
    
    val = val * 100;
    int intVal = [[NSNumber numberWithFloat:val] integerValue];
    NSString *priceString = [NSString stringWithFormat:@"%d", intVal];
    
    NSString *zencartProductID = [NSString stringWithFormat:@"product_id: %@", [self.requestedProductObject objectForKey:@"product_id"]];
    
    if (stripeToken == nil)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"buy token is nil"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
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


-(void)populateDummy
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"emailTextField"] != nil)
        self.emailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"emailTextField"];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"nameTextField"] != nil)
        self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nameTextField"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addressTextField"] != nil)
        self.addressTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressTextField"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityTextField"] != nil)
        self.cityTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityTextField"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"zipTextField"] != nil)
        self.zipTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"zipTextField"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextField"] != nil)
        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextField"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stateTextField"] != nil)
        self.stateTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"stateTextField"];
        
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


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != self.dummyTextField)
        [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}





- (void)viewDidAppear:(BOOL)animated
{
    NSArray *fields = [NSArray arrayWithObjects:self.nameTextField,self.emailTextField, self.phoneTextField, self.addressTextField, self.cityTextField, self.stateTextField, self.zipTextField, self.dummyTextField, nil];
    
    for (int i = 0; i < [fields count]; i++)
        ((UITextField *)[fields objectAtIndex:i]).delegate = self;
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
  
}

- (void)keyboardControls:(BSKeyboardControls *)theKeyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    if (field == self.dummyTextField)
        [self.stpCreditCardNumberTextField.cardNumberField becomeFirstResponder];
    //    UIView *view = theKeyboardControls.activeField.superview.superview;
//        [self.containerScrollView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)theKeyboardControls
{
    [theKeyboardControls.activeField resignFirstResponder];
}






@end
