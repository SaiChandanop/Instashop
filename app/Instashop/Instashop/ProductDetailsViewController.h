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

@class ProductCreateViewController;

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    ProductCreateViewController *parentController;
    
    SizeQuantityTableViewController *sizeQuantityTableViewController;
    
    NSMutableArray *attributesArray;        
    
    UIScrollView *containerScrollView;    
    
    UIImageView *theImageView;

    UILabel *titleLabel;
    
    UITextView *descriptionTextView;
    UIImageView *descriptionBackgroundImageView;
    UIImageView *selectedCategoriesBackgroundImageView;
    UITextField *selectedCategoriesLabel;
    UIButton *selectedCategoriesButton;
    UILabel *retailPriceLabel;
    UITextField *retailPriceTextField;
    UILabel *instashopPriceLabel;
    UITextField *instashopPriceTextField;
    UIButton *nextButton;
    UIButton *addSizeButton;
    UIView *nextButtonContainerView;
    
    //jb added
    UIView *pricesView;
    UIView *sizeQuantityView;
    
    NSDictionary *instragramMediaInfoDictionary;
    NSString *instagramPictureURLString;
    

    CGRect originalPriceViewRect;
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;
- (void) categorySelectionCompleteWithArray:(NSArray *)theArray;

- (IBAction) previewButtonHit;
- (IBAction) categoryButtonHit;

- (IBAction) addSizeButtonHit;
- (void)updateLayout;

@property (nonatomic, retain) IBOutlet ProductCreateViewController *parentController;

@property (nonatomic, retain) SizeQuantityTableViewController *sizeQuantityTableViewController;

@property (nonatomic, retain) NSMutableArray *attributesArray;

@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *theImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UIImageView *descriptionBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *selectedCategoriesBackgroundImageView;
@property (nonatomic, retain) IBOutlet UITextField *selectedCategoriesLabel;
@property (nonatomic, retain) IBOutlet UIButton *selectedCategoriesButton;
@property (nonatomic, retain) IBOutlet UILabel *retailPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *retailPriceTextField;
@property (nonatomic, retain) IBOutlet UILabel *instashopPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *instashopPriceTextField;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *addSizeButton;
@property (nonatomic, retain) IBOutlet UIView *nextButtonContainerView;

@property (nonatomic, retain) IBOutlet UIView *pricesView;
@property (nonatomic, retain) IBOutlet UIView *sizeQuantityView;

@property (nonatomic, retain) NSDictionary *instragramMediaInfoDictionary;
@property (nonatomic, retain) NSString *instagramPictureURLString;

@property (nonatomic, assign) int sizeTableExposedCount;

@property (nonatomic, assign) CGRect originalPriceViewRect;
@end