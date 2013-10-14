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
#import "ISConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NavBarTitleView.h"
#import "ProductAPIHandler.h"

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
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
      
    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SELECT A PHOTO"]];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/recent", @"method", @"-1", @"count", nil];
    self.productSelectTableViewController.parentController = self;
    self.productSelectTableViewController.cellDelegate = self;
    self.productSelectTableViewController.contentRequestParameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [self.productSelectTableViewController refreshContent];
    
    
    
    
}

-(void)backButtonHit
{
    [self.parentController productCreateNavigationControllerExitButtonHit:self.navigationController];
}


-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    ProductDetailsViewController *productDetailsViewController = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
    productDetailsViewController.parentController = self;
    productDetailsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, 320,520);
    [self.navigationController pushViewController:productDetailsViewController animated:YES];
    [productDetailsViewController loadViewsWithInstagramInfoDictionary:theSelectionObject];
}


-(void)previewButtonHitWithProductCreateObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    
    [self previewDoneButtonHit:productCreateContainerObject];
    
    /*
    ProductPreviewViewController *productPreviewViewController = [[ProductPreviewViewController alloc] initWithNibName:@"ProductPreviewViewController" bundle:nil];
    productPreviewViewController.view.frame = CGRectMake(productPreviewViewController.view.frame.origin.x, productPreviewViewController.view.frame.origin.y, productPreviewViewController.view.frame.size.width, productPreviewViewController.view.frame.size.height);
    productPreviewViewController.parentController = self;
    productPreviewViewController.view.frame = productPreviewViewController.view.frame;
    [self.navigationController pushViewController:productPreviewViewController animated:YES];
    [productPreviewViewController loadWithProductCreateObject:productCreateContainerObject];
     */
 
}


- (void)previewDoneButtonHit:(ProductCreateContainerObject *)theCreateObject
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController  *rootVC = delegate.appRootViewController;

    
    if (theCreateObject.mainObject.editingReferenceID != nil)
    {
        [MBProgressHUD showHUDAddedTo:rootVC.view animated:YES].detailsLabelText = @"Editing Product";
        [ProductAPIHandler editProductCreateObject:self withProductCreateObject:theCreateObject];
    
        
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:rootVC.view animated:YES].detailsLabelText = @"Creating Product";
        [CreateProductAPIHandler createProductContainerObject:self withProductCreateObject:theCreateObject];
    }

}



-(void)productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController  *rootVC = delegate.appRootViewController;
    [MBProgressHUD hideAllHUDsForView:rootVC.view animated:NO];
    
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
