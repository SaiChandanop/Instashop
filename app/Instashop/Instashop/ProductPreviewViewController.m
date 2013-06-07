//
//  ProductPreviewViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductPreviewViewController.h"
#import "ImageAPIHandler.h"
#import "ProductCreateViewController.h"
#import "ProductAPIHandler.h"
@interface ProductPreviewViewController ()

@end

@implementation ProductPreviewViewController


@synthesize parentController;

@synthesize productCreateObject;

@synthesize theScrollView;

@synthesize productImageView;
@synthesize titleLabel;
@synthesize descriptionTextField;


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
    

    self.theScrollView.frame = CGRectMake(0,54, self.view.frame.size.width, self.view.frame.size.height - 54);
    [self.view addSubview:self.theScrollView];                                
    // Do any additional setup after loading the view from its nib.
}


-(void)loadWithProductCreateObject:(ProductCreateObject *)theProductCreateObject
{
    self.productCreateObject = theProductCreateObject;
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateObject.instagramPictureURLString withImageView:self.productImageView];
}


- (IBAction) backButtonHit
{
    NSLog(@"backButtonHit");
    [self.parentController vcDidHitBackWithController:self];
}

- (IBAction) postButtonHit
{
    NSLog(@"postButtonHit");

    
    [ProductAPIHandler createNewProductWithDelegate:self withInstagramDataObject:self.productCreateObject.instragramMediaInfoDictionary withTitle:self.productCreateObject.caption withQuantity:self.productCreateObject.quantity withModel:self.productCreateObject.categoryAttribute withPrice:self.productCreateObject.price withWeight:self.productCreateObject.shippingWeight withDescription:self.productCreateObject.description withProductImageURL:self.productCreateObject.instagramPictureURLString];
    
}



@end
