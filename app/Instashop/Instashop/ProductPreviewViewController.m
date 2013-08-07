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

@synthesize productCreateContainerObject;

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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonHit)];
    self.navigationItem.rightBarButtonItem = doneButton;

    
}

-(void)doneButtonHit
{
    [self.parentController previewDoneButtonHit:self.productCreateContainerObject];
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject
{
    self.productCreateContainerObject = theProductCreateContainerObject;
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateContainerObject.mainObject.instagramPictureURLString withImageView:self.productImageView];
}





@end
