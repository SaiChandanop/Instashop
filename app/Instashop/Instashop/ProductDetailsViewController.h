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

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate>
{
    ProductCreateViewController *parentController;
    
    ProductCreateObject *productCreateObject;
    
    UIScrollView *containerScrollView;
    
    UIImageView *productImageView;
    UITextField *captionTextField;
    UITextView *descriptionTextView;
    UITextField *retailTextField;
    UITextField *shippingTextField;
    UITextField *priceTextField;
    UITextField *quantityTextField;
    UIButton *categoryButton;
    UIButton *subcategoryButton;
    UIButton *subSubCategoryButton;
    
    
    NSMutableArray *attributesArray;        
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;

- (IBAction) backButtonHit;
- (IBAction) previewButtonHit;

- (IBAction) categoryButtonHit:(UIButton *)theButton;


-(void)categorySelected:(NSString *)selectedCategory withCategoriesPickerViewController:(CategoriesPickerViewController *)theController;



@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UITextField *captionTextField;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UITextField *retailTextField;
@property (nonatomic, retain) IBOutlet UITextField *shippingTextField;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) IBOutlet UITextField *sizeColorTextField;
@property (nonatomic, retain) IBOutlet UITextField *quantityTextField;
@property (nonatomic, retain) ProductCreateObject *productCreateObject;

@property (nonatomic, retain) NSMutableArray *attributesArray;

@property (nonatomic, retain) IBOutlet UIButton *categoryButton;
@property (nonatomic, retain) IBOutlet UIButton *subcategoryButton;
@property (nonatomic, retain) IBOutlet UIButton *subSubCategoryButton;

@end
