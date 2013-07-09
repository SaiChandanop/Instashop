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


@interface PurchasingAddressViewController ()

@end

@implementation PurchasingAddressViewController

@synthesize doneButtonDelegate;

@synthesize nameTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;


@synthesize checkRatesButton;
@synthesize doneButton;

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
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)checkRatesButtonHit
{
    [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"UPS"];
    [PostmasterAPIHandler makePostmasterRatesCallWithDelegate:self withFromZip:[sellerDictionary objectForKey:@"seller_zip"] withToZip:self.zipTextField.text withWeight:@"1.5" withCarrier:@"FEDEX"];
}


-(void)ratesCallReturnedWithDictionary:(NSDictionary *)returnDict
{
    
    if ([(NSString *)[returnDict objectForKey:@"carrier"] compare:@"UPS"] == NSOrderedSame)
        self.upsRateDictionary = [[NSDictionary alloc] initWithDictionary:returnDict];
    else if ([(NSString *)[returnDict objectForKey:@"carrier"] compare:@"FEDEX"] == NSOrderedSame)
        self.fedexRateDictionary = [[NSDictionary alloc] initWithDictionary:returnDict];
    
    
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


-(IBAction)doneButtonHit
{
    [self.doneButtonDelegate doneButtonHitWithAddressVC:self];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index: %d", buttonIndex);
    
//    self.upsRateDictionary = nil;
//    self.fedexRateDictionary = nil;
    
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
            break;
    }
    
//
    
}
@end
