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
@interface PurchasingAddressViewController ()

@property (nonatomic, retain) NSDictionary *requestedProductObject;


@end

@implementation PurchasingAddressViewController

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
@synthesize sellerDictionary;

@synthesize upsRateDictionary;
@synthesize fedexRateDictionary;

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
    
    /*
     
     */
    
    // Do any additional setup after loading the view from its nib.
}


-(void)loadWithSizeSelection:(NSString *)sizeSelection withQuantitySelection:(NSString *)quantitySelection withProductImage:(UIImage *)productImage
{
    if (sizeSelection == nil)
        self.sizeValueLabel.text = @"";
    else if ([sizeSelection compare:@"(null)"] == NSOrderedSame)
        self.sizeValueLabel.text = @"";
    else
        self.sizeValueLabel.text = sizeSelection;
    
    self.quantityValueLabel.text = quantitySelection;
    self.productImageView.image = productImage;
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
    
    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
    
    self.productBuyButtonLabel.text = [NSString stringWithFormat:@"Buy - %@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.quantityValueLabel.text floatValue] * [[self.requestedProductObject objectForKey:@"products_price"] floatValue]]]];
    
    [SellersAPIHandler makeGetSellersRequestWithDelegate:self withSellerInstagramID:[self.requestedProductObject objectForKey:@"owner_instagram_id"]];
}



-(void)sellersRequestFinishedWithResponseObject:(NSArray *)responseArray
{
    NSLog(@"sellersRequestFinishedWithResponseObject: %@", responseArray);
    self.sellerDictionary = [[NSDictionary alloc] initWithDictionary:[responseArray objectAtIndex:0]];
}


-(IBAction)doneButtonHit
{
    [self.doneButtonDelegate doneButtonHitWithAddressVC:self];
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
            [PostmasterAPIHandler makePostmasterShipRequestCallWithDelegate:self withFromDictionary:theSellerDict withToDictionary:theBuyerDict shippingDictionary:self.upsRateDictionary withPackageDictionary:packageDictionary];
            break;
        case 1:
            [PostmasterAPIHandler makePostmasterShipRequestCallWithDelegate:self withFromDictionary:theSellerDict withToDictionary:theBuyerDict shippingDictionary:self.fedexRateDictionary withPackageDictionary:packageDictionary];
            break;
        default:
            self.upsRateDictionary = nil;
            self.fedexRateDictionary = nil;
            
            break;
    }
    
    //
}

-(void)postmasterShipRequestRespondedWithDictionary:(NSDictionary *)theDict
{
    //    NSLog(@"postmasterShipRequestRespondedWithDictionary theDict: %@", theDict);
    [self.shippingCompleteDelegate postmasterShipCompleteWithPostmasterDictionary:theDict];
    
}


-(IBAction)checkRatesButtonHit
{
    if (self.upsRateDictionary == nil && self.fedexRateDictionary)
    {
        
        [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"UPS"];
        [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"FEDEX"];
        
    }
}


-(void)ratesCallDidFail
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please ensure all fields are filled out correctly"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
}
-(void)ratesCallReturnedWithDictionary:(NSDictionary *)returnDict
{
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

-(IBAction)buyButtonHit
{
    
    [self.addressTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
    [self.stateTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"UPS"];
    [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[self.sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"FEDEX"];
    
    
    
}

@end
