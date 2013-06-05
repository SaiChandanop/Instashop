//
//  ProductCreateViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductCreateViewController.h"
#import "ProductAPIHandler.h"
#import "AppRootViewController.h"


@interface ProductCreateViewController ()

@end

@implementation ProductCreateViewController

@synthesize productSelectTableViewController, productDetailsViewController;
@synthesize contentScrollView;
@synthesize titleTextField, quantityTextField, modelTextField, priceTextField, weightField, descriptionTextView;
@synthesize productDictionary;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentScrollView.backgroundColor = [UIColor clearColor];
    
    self.productSelectTableViewController.parentController = self;
}

-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary
{
    if ([self.productDetailsViewController.view superview] == nil)
    {
        self.productDetailsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
        [self.view addSubview:self.productDetailsViewController.view];
    }

    self.productDetailsViewController.parentController = self;
    [self.productDetailsViewController loadViewsWithInstagramInfoDictionary:theInstagramInfoDictionary];

    
    self.productDetailsViewController.containerScrollView.contentSize = CGSizeMake(1401, 1402);

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.productDetailsViewController.view.frame = CGRectMake(0, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [UIView commitAnimations];

}

-(void)productDetailsViewControllerBackButtonHit
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.productDetailsViewController.view.frame = CGRectMake(self.productDetailsViewController.view.frame.size.width, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    NSLog(@"self.contentScrollView.contentSize1: %@", NSStringFromCGSize(self.contentScrollView.contentSize));
    
    if (self.contentScrollView.contentSize.height < 569)
        self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}


-(IBAction)goButtonHit
{
    NSLog(@"quantityTextField: %@", quantityTextField.text);
    NSLog(@"modelTextField: %@", modelTextField.text);
    NSLog(@"priceTextField: %@", priceTextField.text);
    NSLog(@"weightField: %@", weightField.text);
    
    if ([self.titleTextField.text length] > 0)
    if ([quantityTextField.text length] > 0)
        if ([modelTextField.text length] > 0)
            if ([priceTextField.text length] > 0)
                if ([weightField.text length] > 0)
                    if ([descriptionTextView.text length] > 0)
                        [ProductAPIHandler createNewProductWithDelegate:self withInstagramDataObject:self.productDictionary withTitle:self.titleTextField.text withQuantity:quantityTextField.text withModel:modelTextField.text withPrice:priceTextField.text withWeight:weightField.text withDescription:self.descriptionTextView.text];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    [theTextField resignFirstResponder];
    if(theTextField == weightField)
        [self goButtonHit];
    
    return YES;

}


-(IBAction)exitButtonHit
{
    [[AppRootViewController sharedRootViewController] exitButtonHitWithViewController:self];
}


@end
