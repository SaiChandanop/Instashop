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

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource>
{
    ProductCreateViewController *parentController;
    
    SizeQuantityTableViewController *sizeQuantityTableViewController;
    
    NSMutableArray *attributesArray;        
    
    UIScrollView *containerScrollView;    
    UIView *subCategoryContainerView;
    
    UIImageView *theImageView;
    UITextField *titleTextField;
    UITextField *descriptionTextField;
    UITextField *selectedCategoriesLabel;
    UILabel *retailPriceLabel;
    UITextField *retailPriceTextField;
    UILabel *instashopPriceLabel;
    UITextField *instashopPriceTextField;
    UIButton *nextButton;
    UIButton *addSizeButton;
    UIView *nextButtonContainerView;
    
    //jb added
    UIView *descriptionView;
    UIView *pricesView;
    UIView *sizeQuantityView;
    
    NSDictionary *instragramMediaInfoDictionary;
    NSString *instagramPictureURLString;
    

    CGRect originalPriceViewRect;
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;
- (void) categorySelectionCompleteWithArray:(NSArray *)theArray;

- (IBAction) backButtonHit;
- (IBAction) previewButtonHit;
- (IBAction) categoryButtonHit;

- (IBAction) addSizeButtonHit;

@property (nonatomic, retain) IBOutlet ProductCreateViewController *parentController;

@property (nonatomic, retain) SizeQuantityTableViewController *sizeQuantityTableViewController;

@property (nonatomic, retain) NSMutableArray *attributesArray;

@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, retain) IBOutlet UIView *subCategoryContainerView;

@property (nonatomic, retain) IBOutlet UIImageView *theImageView;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, retain) IBOutlet UITextField *selectedCategoriesLabel;
@property (nonatomic, retain) IBOutlet UILabel *retailPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *retailPriceTextField;
@property (nonatomic, retain) IBOutlet UILabel *instashopPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *instashopPriceTextField;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *addSizeButton;
@property (nonatomic, retain) IBOutlet UIView *nextButtonContainerView;

@property (nonatomic, retain) IBOutlet UIView *descriptionView;
@property (nonatomic, retain) IBOutlet UIView *pricesView;
@property (nonatomic, retain) IBOutlet UIView *sizeQuantityView;

@property (nonatomic, retain) NSDictionary *instragramMediaInfoDictionary;
@property (nonatomic, retain) NSString *instagramPictureURLString;

@property (nonatomic, assign) int sizeTableExposedCount;

@property (nonatomic, assign) CGRect originalPriceViewRect;
@end