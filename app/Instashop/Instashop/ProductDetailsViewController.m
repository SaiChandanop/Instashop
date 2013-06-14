//
//  ProductDetailsViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ImageAPIHandler.h"
#import "ProductCreateViewController.h"
#import "ProductCreateObject.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

@synthesize parentController, containerScrollView, productImageView;

@synthesize captionTextField;
@synthesize descriptionTextView;
@synthesize retailTextField;
@synthesize shippingTextField;
@synthesize priceTextField;
@synthesize categoryTextField;
@synthesize sizeColorTextField;
@synthesize quantityTextField;

@synthesize productCreateObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:116.0f/255.0f blue:93.0f/255.0f alpha:1];
    
    self.captionTextField.delegate = self;
    
    self.descriptionTextView.delegate = self;
    self.retailTextField.delegate = self;
    self.shippingTextField.delegate = self;
    self.priceTextField.delegate = self;
    self.categoryTextField.delegate = self;
    self.sizeColorTextField.delegate = self;
    self.quantityTextField.delegate = self;
}


- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    // +++ This is unnecessary if the scroll view is part of the main view in the xib +++ //
    
    //self.containerScrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    //[self.view addSubview:self.containerScrollView];
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 640);

    
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];

    NSString *instagramProductImageURLString = [startResultionDictionary objectForKey:@"url"];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.productImageView];
    
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];

    if (captionDictionary != nil)
        if (![captionDictionary isKindOfClass:[NSNull class]])
            self.captionTextField.text = [captionDictionary objectForKey:@"text"];


    self.productCreateObject = [[ProductCreateObject alloc] init];
    self.productCreateObject.instragramMediaInfoDictionary = theDictionary;
    self.productCreateObject.instagramPictureURLString = instagramProductImageURLString;
}

-(IBAction)backButtonHit
{
    [parentController vcDidHitBackWithController:self];
}

-(IBAction)previewButtonHit
{        
    self.productCreateObject.caption = self.captionTextField.text;
    self.productCreateObject.description = self.descriptionTextView.text;
    self.productCreateObject.retailValue = self.retailTextField.text;
    self.productCreateObject.shippingWeight = self.shippingTextField.text;
    self.productCreateObject.price = self.priceTextField.text;
    self.productCreateObject.category = self.categoryTextField.text;
    self.productCreateObject.categoryAttribute = self.sizeColorTextField.text;
    self.productCreateObject.quantity = self.quantityTextField.text;
    [self.parentController previewButtonHitWithProductCreateObject:self.productCreateObject];
    
    
    
    [self.captionTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    [self.retailTextField resignFirstResponder];
    [self.shippingTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.sizeColorTextField resignFirstResponder];
    [self.quantityTextField resignFirstResponder];    

}



@end
