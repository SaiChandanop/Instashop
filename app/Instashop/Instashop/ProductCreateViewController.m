//
//  ProductCreateViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductCreateViewController.h"
#import "ProductAPIHandler.h"


@interface ProductCreateViewController ()

@end

@implementation ProductCreateViewController


@synthesize quantityTextField, modelTextField, priceTextField, weightField;
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
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)goButtonHit
{
    NSLog(@"quantityTextField: %@", quantityTextField.text);
    NSLog(@"modelTextField: %@", modelTextField.text);
    NSLog(@"priceTextField: %@", priceTextField.text);
    NSLog(@"weightField: %@", weightField.text);
    
    if ([quantityTextField.text length] > 0)
        if ([modelTextField.text length] > 0)
            if ([priceTextField.text length] > 0)
                if ([weightField.text length] > 0)
                    [ProductAPIHandler craeteNewProductWithDelegate:self withInstagramDataObject:self.productDictionary withQuantity:quantityTextField.text withModel:modelTextField.text withPrice:priceTextField.text withWeight:weightField.text];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    [theTextField resignFirstResponder];
    if(theTextField == weightField)
        [self goButtonHit];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
@end
