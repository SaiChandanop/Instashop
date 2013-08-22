//
//  PurchasingAddressViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "RatesCallHandlerProtocol.h"
#import "SellersRequestFinishedProtocol.h"
#import "ProductPurchaseCompleteProtocol.h"
#import "PostmasterShipResponseProtocol.h"
#import "STPView.h"
#import "ISDarkRowContainerView.h"
#import "ISLightRowContainerView.h"

@interface PurchasingAddressViewController : UIViewController <UIActionSheetDelegate, RatesCallHandlerProtocol, SellersRequestFinishedProtocol, ProductPurchaseCompleteProtocol, PostmasterShipResponseProtocol>
{
    id doneButtonDelegate;    
    id shippingCompleteDelegate;
    
    
    TPKeyboardAvoidingScrollView *contentScrollView;
    
    UIView *productDetailsPlacementView;
    UIView *productDetailsContentView;
    UIView *purchaseDetailsContentView;
    
    UIImageView *productImageView;
    UILabel *productTitleLabel;
    UILabel *sizeValueLabel;
    UILabel *sizeTextLabel;
    UILabel *quantityValueLabel;
    UILabel *quantityTextLabel;
    UILabel *priceValueLabel;
    UILabel *priceTextLabel;
    
    ISDarkRowContainerView *nameView;
    ISLightRowContainerView *emailView;
    ISDarkRowContainerView  *phoneView;

    ISDarkRowContainerView *addressView;
    ISLightRowContainerView *cityStateView;
    ISDarkRowContainerView  *zipView;
    
    UITextField *nameTextField;
    UITextField *addressTextField;
    UITextField *cityTextField;
    UITextField *stateTextField;
    UITextField *zipTextField;
    UITextField *phoneTextField;
    
    
    UIView *creditCardContainerView;
    PKView *stpCreditCardNumberTextField;
    
    
    UIButton *checkRatesButton;
    UIButton *doneButton;
    
    UILabel *productBuyButtonLabel;
    
    NSDictionary *productCategoryDictionary;
    NSDictionary *sellerDictionary;
    NSDictionary *upsRateDictionary;
    NSDictionary *fedexRateDictionary;
    
    NSDictionary *requestedPostmasterDictionary;
    
    
}


-(void)loadWithSizeSelection:(NSString *)sizeSelection withQuantitySelection:(NSString *)quantitySelection withProductImage:(UIImage *)productImage;
-(void)loadWithRequestedProductObject:(NSDictionary *)theProductObject;
-(IBAction)doneButtonHit;
-(IBAction)buyButtonHit;
-(void)ratesCallDidFail;
-(void)ratesCallReturnedWithDictionary:(NSDictionary *)returnDict;

-(void)tokenCreatedWithDictionary:(NSDictionary *)dict;

@property (nonatomic, retain) id doneButtonDelegate;
@property (nonatomic, retain) id shippingCompleteDelegate;


@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UIView *productDetailsPlacementView;
@property (nonatomic, retain) IBOutlet UIView *productDetailsContentView;
@property (nonatomic, retain) IBOutlet UIView *purchaseDetailsContentView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UILabel *productTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizeValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizeTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *quantityValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *quantityTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceTextLabel;



@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *nameView;
@property (nonatomic, retain) IBOutlet ISLightRowContainerView *emailView;
@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *phoneView;

@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *addressView;
@property (nonatomic, retain) IBOutlet ISLightRowContainerView *cityStateView;
@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *zipView;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;


@property (nonatomic, retain) IBOutlet UIView *creditCardContainerView;
@property (nonatomic, retain) IBOutlet PKView *stpCreditCardNumberTextField;

@property (nonatomic, retain) IBOutlet UIButton *checkRatesButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UILabel *productBuyButtonLabel;

@property (nonatomic, retain) NSDictionary *productCategoryDictionary;
@property (nonatomic, retain) NSDictionary *sellerDictionary;
@property (nonatomic, retain) NSDictionary *upsRateDictionary;
@property (nonatomic, retain) NSDictionary *fedexRateDictionary;

@property (nonatomic, retain) NSDictionary *requestedPostmasterDictionary;

@end


