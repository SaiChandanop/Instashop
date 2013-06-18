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

@synthesize parentController;
@synthesize productSelectTableViewController, productDetailsViewController;
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
    
    self.productSelectTableViewController.parentController = self;
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbarBG.png"]  forBarMetrics:UIBarMetricsDefault];
    
    
    NSLog(@"ProductCreateViewController view did load");
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonHit)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;

    


    
}

-(void)backButtonHit
{
    [self.parentController productCreateNavigationControllerExitButtonHit:self.navigationController];
}

-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary
{
    self.productDetailsViewController.containerScrollView.contentSize = CGSizeMake(0, 1400);
    self.productDetailsViewController.parentController = self;
    [self.productDetailsViewController loadViewsWithInstagramInfoDictionary:theInstagramInfoDictionary];
    [self.navigationController pushViewController:self.productDetailsViewController animated:YES];
    self.productDetailsViewController.containerScrollView.contentSize = CGSizeMake(0, 1400);    
}


-(void)previewButtonHitWithProductCreateObject:(ProductCreateObject *)productCreateObject
{
    self.productPreviewViewController = [[ProductPreviewViewController alloc] initWithNibName:@"ProductPreviewViewController" bundle:nil];
    self.productPreviewViewController.parentController = self;
    self.productPreviewViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [self.productPreviewViewController loadWithProductCreateObject:productCreateObject];
    [self.navigationController pushViewController:self.productPreviewViewController animated:YES];
    
    self.productPreviewViewController.theScrollView.contentSize = CGSizeMake(0, 1400);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonHit)];
    self.productPreviewViewController.navigationItem.rightBarButtonItem = doneButton;
    
}



- (void)doneButtonHit
{
    ProductCreateObject *productCreateObject = self.productPreviewViewController.productCreateObject;
    
    [ProductAPIHandler createNewProductWithDelegate:self withInstagramDataObject:productCreateObject.instragramMediaInfoDictionary withTitle:productCreateObject.caption withQuantity:productCreateObject.quantity withModel:productCreateObject.categoryAttribute withPrice:productCreateObject.price withWeight:productCreateObject.shippingWeight withDescription:productCreateObject.description withProductImageURL:productCreateObject.instagramPictureURLString];

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Product Created!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Smashing"
                                              otherButtonTitles:nil];
    [alertView show];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backButtonHit];
}


@end
