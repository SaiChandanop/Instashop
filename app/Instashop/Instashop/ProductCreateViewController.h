//
//  ProductCreateViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectTableViewController.h"
@interface ProductCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    ProductSelectTableViewController *productSelectTableViewController;
    
    
    UIScrollView *contentScrollView;
    
    UITextField *titleTextField;
    UITextField *quantityTextField;
    UITextField *modelTextField;
    UITextField *priceTextField;
    UITextField *weightField;
    UITextView *descriptionTextView;
    
    NSDictionary *productDictionary;
}

- (IBAction) exitButtonHit;

- (IBAction) goButtonHit;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *quantityTextField;
@property (nonatomic, retain) IBOutlet UITextField *modelTextField;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) IBOutlet UITextField *weightField;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, retain) NSDictionary *productDictionary;
@end
