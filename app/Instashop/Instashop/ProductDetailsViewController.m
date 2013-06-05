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
    
    self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:116.0f/255.0f blue:93.0f/255.0f alpha:1];
}


- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    
    self.containerScrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width  * 2, self.view.frame.size.height * 2);

    
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[startResultionDictionary objectForKey:@"url"] withImageView:self.productImageView];
    
    
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];
    self.captionTextField.text = [captionDictionary objectForKey:@"text"];
    
    
    NSLog(@"theDictionary: %@", theDictionary);
    
}

-(IBAction)backButtonHit
{
    [parentController productDetailsViewControllerBackButtonHit];
}



-(IBAction)previewButtonHit
{
    NSLog(@"captionTextField.text: %@", captionTextField.text);
    
    NSLog(@"descriptionTextView.text: %@", descriptionTextView.text);
    NSLog(@"retailTextField.text: %@", retailTextField.text);
    NSLog(@"shippingTextField.text: %@", shippingTextField.text);
    NSLog(@"priceTextField.text: %@", priceTextField.text);
    NSLog(@"categoryTextField.text: %@", categoryTextField.text);
    NSLog(@"sizeColorTextField.text: %@", sizeColorTextField.text);
    NSLog(@"quantityTextField.text: %@", quantityTextField.text);


}



@end
