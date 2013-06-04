//
//  ProductCreateViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectTableViewController.h"
#import "ProductDetailsViewController.h"

@interface ProductCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    ProductSelectTableViewController *productSelectTableViewController;
    ProductDetailsViewController *productDetailsViewController;
    
    
    UIScrollView *contentScrollView;
    
    UITextField *titleTextField;
    UITextField *quantityTextField;
    UITextField *modelTextField;
    UITextField *priceTextField;
    UITextField *weightField;
    UITextView *descriptionTextView;
    
    NSDictionary *productDictionary;
}

-(void)productDetailsViewControllerBackButtonHit;
-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary;


- (IBAction) exitButtonHit;
- (IBAction) goButtonHit;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet ProductDetailsViewController *productDetailsViewController;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *quantityTextField;
@property (nonatomic, retain) IBOutlet UITextField *modelTextField;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) IBOutlet UITextField *weightField;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, retain) NSDictionary *productDictionary;
@end
