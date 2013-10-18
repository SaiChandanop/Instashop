//
//  ProductPreviewViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCreateContainerObject.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SizeQuantityTableViewController.h"

@class  ProductCreateViewController;

@interface ProductPreviewViewController : UIViewController
{
    ProductCreateViewController *parentController;
    ProductCreateContainerObject *productCreateContainerObject;
    
    TPKeyboardAvoidingScrollView *contentScrollView;
    
    UIImageView *productImageView;
    UILabel *titleLabel;
    UITextView *descriptionTextField;
    UIImageView *descriptionBackgroundImageView;
    
    UIView *bottomContentView;
    UITextField *categoryTextField;
    UIImageView *categoryBackgroundImageView;
    UITextField *listPriceValueTextField;
    UITextField *shippingValueTextField;
    UIButton *sellButton;
    
    UITextField *urlTextField;
    
    
    SizeQuantityTableViewController *sizeQuantityTableViewController;
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject;

- (IBAction) postButtonHit;

@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) ProductCreateContainerObject *productCreateContainerObject;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;    
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextField;
@property (nonatomic, retain) IBOutlet UIImageView *descriptionBackgroundImageView;

@property (nonatomic, retain) IBOutlet UIView *bottomContentView;
@property (nonatomic, retain) IBOutlet UITextField *categoryTextField;
@property (nonatomic, retain) IBOutlet UIImageView *categoryBackgroundImageView;
@property (nonatomic, retain) IBOutlet UITextField *listPriceValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *shippingValueTextField;
@property (nonatomic, retain) IBOutlet UIButton *sellButton;
@property (nonatomic, retain) IBOutlet UITextField *urlTextField;

@property (nonatomic, retain) IBOutlet SizeQuantityTableViewController *sizeQuantityTableViewController;
@end
