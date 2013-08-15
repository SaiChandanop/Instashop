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


@class  ProductCreateViewController;

@interface ProductPreviewViewController : UIViewController
{
    ProductCreateViewController *parentController;
    ProductCreateContainerObject *productCreateContainerObject;
    
    TPKeyboardAvoidingScrollView *theScrollView;
    
    UIImageView *productImageView;
    UITextField *titleTextField;
    UITextView *descriptionTextField;
    
    UIView *bottomContentView;
    UITextField *categoryTextField;
    UITextField *listPriceValueTextField;
    UITextField *shippingValueTextField;
    UIButton *sellButton;
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject;

- (IBAction) postButtonHit;

@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) ProductCreateContainerObject *productCreateContainerObject;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *theScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextField;

@property (nonatomic, retain) IBOutlet UIView *bottomContentView;
@property (nonatomic, retain) IBOutlet UITextField *categoryTextField;
@property (nonatomic, retain) IBOutlet UITextField *listPriceValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *shippingValueTextField;
@property (nonatomic, retain) IBOutlet UIButton *sellButton;
@end
