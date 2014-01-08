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

@property (nonatomic, strong) ProductCreateViewController *parentController;

@property (nonatomic, strong) ProductCreateContainerObject *productCreateContainerObject;

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingScrollView *contentScrollView;

@property (nonatomic, strong) IBOutlet UIImageView *productImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;    
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextField;
@property (nonatomic, strong) IBOutlet UIImageView *descriptionBackgroundImageView;

@property (nonatomic, strong) IBOutlet UIView *bottomContentView;
@property (nonatomic, strong) IBOutlet UITextField *categoryTextField;
@property (nonatomic, strong) IBOutlet UIImageView *categoryBackgroundImageView;
@property (nonatomic, strong) IBOutlet UITextField *listPriceValueTextField;
@property (nonatomic, strong) IBOutlet UITextField *shippingValueTextField;
@property (nonatomic, strong) IBOutlet UIButton *sellButton;
@property (nonatomic, strong) IBOutlet UITextField *urlTextField;

@property (nonatomic, strong) IBOutlet SizeQuantityTableViewController *sizeQuantityTableViewController;
@end
