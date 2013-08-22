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

#import "ISDarkRowContainerView.h"
#import "ISLightRowContainerView.h"

@class ProductCreateViewController;

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    ProductCreateViewController *parentController;
    SizeQuantityTableViewController *sizeQuantityTableViewController;
    
    NSMutableArray *attributesArray;
    NSDictionary *instragramMediaInfoDictionary;
    NSString *instagramPictureURLString;
    CGRect originalPriceViewRect;
    
    UIScrollView *containerScrollView;

    
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
    
    UIView *pricesView;
    
    
    
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;
- (void) categorySelectionCompleteWithArray:(NSArray *)theArray;

- (IBAction) previewButtonHit;
- (IBAction) categoryButtonHit;

- (IBAction) addSizeButtonHit;
- (void) updateLayout;

@property (nonatomic, retain) ProductCreateViewController *parentController;
@property (nonatomic, retain) SizeQuantityTableViewController *sizeQuantityTableViewController;

@property (nonatomic, retain) NSMutableArray *attributesArray;
@property (nonatomic, retain) NSDictionary *instragramMediaInfoDictionary;
@property (nonatomic, retain) NSString *instagramPictureURLString;
@property (nonatomic, assign) int sizeTableExposedCount;
@property (nonatomic, assign) CGRect originalPriceViewRect;


@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;


@property (nonatomic, retain) IBOutlet UIImageView *theImageView;
@property (nonatomic, retain) IBOutlet UITextView *titleTextView;

@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *descriptionContainerView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;


@property (nonatomic, retain) IBOutlet ISLightRowContainerView *categoriesContainerView;
@property (nonatomic, retain) IBOutlet UITextField *selectedCategoriesLabel;

@property (nonatomic, retain) IBOutlet ISDarkRowContainerView *retailPriceContainerView;
@property (nonatomic, retain) IBOutlet UITextField *retailPriceTextField;

@property (nonatomic, retain) IBOutlet ISLightRowContainerView *instashopPriceContainerView;
@property (nonatomic, retain) IBOutlet UITextField *instashopPriceTextField;

@property (nonatomic, retain) UIView *sizeQuantityView;
@property (nonatomic, retain) IBOutlet UIButton *addSizeButton;

@property (nonatomic, retain) IBOutlet UIView *pricesView;


@end