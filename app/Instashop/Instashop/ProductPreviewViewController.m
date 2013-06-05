//
//  ProductPreviewViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductPreviewViewController.h"
#import "ImageAPIHandler.h"

@interface ProductPreviewViewController ()

@end

@implementation ProductPreviewViewController

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
    // Do any additional setup after loading the view from its nib.
}


-(void)loadWithProductCreateObject:(ProductCreateObject *)theProductCreateObject
{
    self.productCreateObject = theProductCreateObject;
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateObject.instagramURLString withImageView:self.productImageView];
    
    
}

@end
