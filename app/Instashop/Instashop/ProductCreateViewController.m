//
//  ProductCreateViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductCreateViewController.h"
#import "CreateProductAPIHandler.h"
#import "AppRootViewController.h"

@interface ProductCreateViewController ()

@end

@implementation ProductCreateViewController

@synthesize parentController;
@synthesize productSelectTableViewController;
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
    
    NSLog(@"productDictionary: %@", productDictionary);

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbarBG.png"]  forBarMetrics:UIBarMetricsDefault];
    
    
//    NSLog(@"ProductCreateViewController view did load");
    
    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backbutton.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    self.productSelectTableViewController.parentController = self;
}

-(void)backButtonHit
{
    [self.parentController productCreateNavigationControllerExitButtonHit:self.navigationController];
}

-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary
{
//    NSLog(@"theInstagramInfoDictionary: %@", theInstagramInfoDictionary);
    
    NSLog(@"self.navigationController: %@", self.navigationController);
    ProductDetailsViewController *productDetailsViewController = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
    productDetailsViewController.parentController = self;
    productDetailsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, 320,520);
    [self.navigationController pushViewController:productDetailsViewController animated:YES];
    [productDetailsViewController loadViewsWithInstagramInfoDictionary:theInstagramInfoDictionary];    
}


-(void)previewButtonHitWithProductCreateObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    ProductPreviewViewController *productPreviewViewController = [[ProductPreviewViewController alloc] initWithNibName:@"ProductPreviewViewController" bundle:nil];
    productPreviewViewController.parentController = self;
    productPreviewViewController.view.frame = productPreviewViewController.view.frame;
    [self.navigationController pushViewController:productPreviewViewController animated:YES];
    [productPreviewViewController loadWithProductCreateObject:productCreateContainerObject];
    

}


- (void)previewDoneButtonHit:(ProductCreateContainerObject *)theCreateObject
{
    [CreateProductAPIHandler createProductContainerObject:self withProductCreateObject:theCreateObject];
}



-(void)productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    NSMutableArray *ar = [NSMutableArray arrayWithArray:productCreateContainerObject.objectSizePermutationsArray];
    
    int count = [ar count];
    
    for (int i = 0; i < count; i++)
    {
        ProductCreateObject *obj = [ar objectAtIndex:0];
        [CreateProductAPIHandler createProductSizeQuantityObjects:self withProductObject:obj withProductID:productID];
        [ar removeObject:obj];
    }
    
    
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
