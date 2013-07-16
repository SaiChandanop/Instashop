//
//  ProductDetailsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCreateObject.h"
#import "CategoriesPickerViewController.h"

@class ProductCreateViewController;

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource>
{
    ProductCreateViewController *parentController;
    ProductCreateObject *productCreateObject;
    
    NSMutableArray *attributesArray;        
    
    UIScrollView *containerScrollView;    
    UIView *subCategoryContainerView;
    UITableView *categorySizeQuantityTableView;
    
    UIImageView *theImageView;
    UITextField *titleTextField;
    UITextField *descriptionTextField;
    UILabel *selectedCategoriesLabel;
    UILabel *retailPriceLabel;
    UITextField *retailPriceTextField;
    UILabel *instashopPriceLabel;
    UITextField *instashopPriceTextField;
    UIButton *nextButton;
    
    
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;

- (IBAction) backButtonHit;
- (IBAction) previewButtonHit;
- (IBAction) categoryButtonHit;



-(void)categorySelected:(NSString *)selectedCategory withCategoriesPickerViewController:(CategoriesPickerViewController *)theController;


@property (nonatomic, retain) ProductCreateObject *productCreateObject;
@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) NSMutableArray *attributesArray;

@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, retain) IBOutlet UIView *subCategoryContainerView;
@property (nonatomic, retain) IBOutlet UITableView *categorySizeQuantityTableView;


@property (nonatomic, retain) IBOutlet UIImageView *theImageView;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, retain) IBOutlet UILabel *selectedCategoriesLabel;
@property (nonatomic, retain) IBOutlet UILabel *retailPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *retailPriceTextField;
@property (nonatomic, retain) IBOutlet UILabel *instashopPriceLabel;
@property (nonatomic, retain) IBOutlet UITextField *instashopPriceTextField;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;


@end