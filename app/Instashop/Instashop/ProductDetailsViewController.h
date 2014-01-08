//
//  ProductDetailsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCreateObject.h"
#import "CategoriesTableViewController.h"
#import "CategoriesViewController.h"
#import "SizeQuantityTableViewController.h"
#import "IGRequest.h"
#import "ISDarkRowContainerView.h"
#import "ISLightRowContainerView.h"
#import "CIALBrowserViewController.h"
#import "EditProductCompleteProtocol.h"
#import "ProductCreateContainerProtocol.h"

@class ProductCreateViewController;

@interface ProductDetailsViewController : UIViewController <IGRequestDelegate, UITextFieldDelegate, UITextViewDelegate, EditProductCompleteProtocol, ProductCreateContainerProtocol>
{
    ProductCreateViewController *parentController;
    SizeQuantityTableViewController *sizeQuantityTableViewController;
    
    NSMutableArray *attributesArray;
    NSDictionary *instragramMediaInfoDictionary;
    NSString *instagramPictureURLString;
    CGRect originalPriceViewRect;
    NSDictionary *editingProductObject;
    UIScrollView *containerScrollView;
    NSString *editingProductID;
    
    UIImageView *theImageView;

    UITextView *titleTextView;
    
    ISDarkRowContainerView *descriptionContainerView;
    UITextView *descriptionTextView;

    ISLightRowContainerView *categoriesContainerView;
    UITextField *selectedCategoriesLabel;
    
    ISDarkRowContainerView *retailPriceContainerView;
    UITextField *retailPriceTextField;

    ISLightRowContainerView *instashopPriceContainerView;
    UITextField *instashopPriceTextField;
    
    UIView *sizeQuantityView;
    UIButton *addSizeButton;
    
    UILabel *urlLabel;
    
    UIView *pricesView;

    ISLightRowContainerView *urlContainerView;

    ISLightRowContainerView *socialButtonContainerView;
    UIButton *facebookButton;
    UIButton *twitterButton;
    UIButton *urlButton;
    UIButton *nextButton;
    
    CIALBrowserViewController *browserViewController;
    BOOL isEdit;
}

- (void) loadWithProductObject:(NSDictionary *)productObject withMediaInstagramID:(NSString *)mediaInstagramID;

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;
- (void) categorySelectionCompleteWithArray:(NSArray *)theArray;

- (IBAction) previewButtonHit;
- (IBAction) categoryButtonHit;

- (IBAction) addSizeButtonHit;
- (void) updateLayout;

- (IBAction) urlButtonHit;

- (IBAction) facebookButtonHit;
- (IBAction) twitterButtonHit;


@property (nonatomic, strong) ProductCreateViewController *parentController;
@property (nonatomic, strong) SizeQuantityTableViewController *sizeQuantityTableViewController;

@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSDictionary *instragramMediaInfoDictionary;
@property (nonatomic, strong) NSDictionary *editingProductObject;
@property (nonatomic, strong) NSString *instagramPictureURLString;
@property (nonatomic, assign) int sizeTableExposedCount;
@property (nonatomic, assign) CGRect originalPriceViewRect;
@property (nonatomic, strong) NSString *editingProductID;

@property (nonatomic, strong) IBOutlet UIScrollView *containerScrollView;


@property (nonatomic, strong) IBOutlet UIImageView *theImageView;
@property (nonatomic, strong) IBOutlet UITextView *titleTextView;

@property (nonatomic, strong) IBOutlet ISDarkRowContainerView *descriptionContainerView;
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextView;


@property (nonatomic, strong) IBOutlet ISLightRowContainerView *categoriesContainerView;
@property (nonatomic, strong) IBOutlet UITextField *selectedCategoriesLabel;

@property (nonatomic, strong) IBOutlet ISDarkRowContainerView *retailPriceContainerView;
@property (nonatomic, strong) IBOutlet UITextField *retailPriceTextField;

@property (nonatomic, strong) IBOutlet ISLightRowContainerView *instashopPriceContainerView;
@property (nonatomic, strong) IBOutlet UITextField *instashopPriceTextField;

@property (nonatomic, strong) UIView *sizeQuantityView;
@property (nonatomic, strong) IBOutlet UIButton *addSizeButton;
@property (nonatomic, strong) IBOutlet UILabel *urlLabel;

@property (nonatomic, strong) IBOutlet UIView *pricesView;

@property (nonatomic, strong) IBOutlet ISLightRowContainerView *urlContainerView;

@property (nonatomic, strong) IBOutlet ISLightRowContainerView *socialButtonContainerView;
@property (nonatomic, strong) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterButton;
@property (nonatomic, strong) IBOutlet UIButton *urlButton;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) CIALBrowserViewController *browserViewController;
@property (nonatomic, assign) BOOL isEdit;
@end