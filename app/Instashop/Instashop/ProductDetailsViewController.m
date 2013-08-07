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
#import "AttributesManager.h"
#import "SizeQuantityTableViewCell.h"
#import "ProductCreateContainerObject.h"


@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

@synthesize sizeQuantityTableViewController;
@synthesize parentController;
@synthesize attributesArray;
@synthesize containerScrollView;
@synthesize subCategoryContainerView;
@synthesize categorySizeQuantityTableView;
@synthesize theImageView;
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize selectedCategoriesLabel;
@synthesize retailPriceTextField;
@synthesize instashopPriceTextField;
@synthesize nextButton;
@synthesize nextButtonContainerView;
@synthesize retailPriceLabel;
@synthesize instashopPriceLabel;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    
    [self.view addSubview:self.containerScrollView];
    
    self.titleTextField.delegate = self;
    self.titleTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    
    self.descriptionTextField.delegate = self;
    self.descriptionTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    
    self.retailPriceTextField.delegate = self;
    self.retailPriceLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    self.retailPriceTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    
    self.instashopPriceTextField.delegate = self;
    self.instashopPriceLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    self.instashopPriceTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    
    self.selectedCategoriesLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cpbackimage.png"]];
    
    self.attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.subCategoryContainerView.backgroundColor = self.view.backgroundColor;
    [self.containerScrollView bringSubviewToFront:self.subCategoryContainerView];
    
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.subCategoryContainerView.frame.origin.y + self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 8);
        
}

- (IBAction) categoryButtonHit
{
    
    CategoriesNavigationViewController *categoriesNavigationViewController = [[CategoriesNavigationViewController alloc] initWithNibName:nil bundle:nil];
    categoriesNavigationViewController.parentController = self;
    [self.navigationController pushViewController:categoriesNavigationViewController animated:YES];
        
}

-(void)categorySelectionCompleteWithArray:(NSArray *)theArray
{
    [self.attributesArray removeAllObjects];
    
    [self.attributesArray addObjectsFromArray:theArray];
    
    NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.attributesArray count]; i++)
    {
        [titleString appendString:[NSString stringWithFormat:@" %@", [self.attributesArray objectAtIndex:i]]];
        if (i != [self.attributesArray count] -1)
            [titleString appendString:@" >"];
        
    }
    self.selectedCategoriesLabel.text = titleString;
 
    if (self.sizeQuantityTableViewController == nil)
    {
        self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:nil bundle:nil];
        self.sizeQuantityTableViewController.sizesArray = [[NSArray alloc] initWithArray:[[AttributesManager getSharedAttributesManager] getSizesWithArray:self.attributesArray]];
        self.sizeQuantityTableViewController.view.frame = CGRectMake(0, self.selectedCategoriesLabel.frame.origin.y + self.selectedCategoriesLabel.frame.size.height, self.view.frame.size.width, 150);
        [self.containerScrollView addSubview:self.sizeQuantityTableViewController.view];
    }
    
    self.subCategoryContainerView.frame = CGRectMake(0, self.sizeQuantityTableViewController.view.frame.origin.y + self.sizeQuantityTableViewController.view.frame.size.height, self.view.frame.size.width, self.subCategoryContainerView.frame.size.height);
    self.containerScrollView.contentSize = CGSizeMake(0, self.subCategoryContainerView.frame.origin.y + self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 8);
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    // +++ This is unnecessary if the scroll view is part of the main view in the xib +++ //
    
    //self.containerScrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    //[self.view addSubview:self.containerScrollView];
    
    //    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 480);
    
    
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    
    NSString *instagramProductImageURLString = [startResultionDictionary objectForKey:@"url"];
    //    NSLog(@"instagramProductImageURLString: %@", instagramProductImageURLString);
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.theImageView];
    //    NSLog(@"self.theImageView: %@", self.theImageView);
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];
    
    //    NSLog(@"self.titleTextField: %@", self.titleTextField);
    if (captionDictionary != nil)
        if (![captionDictionary isKindOfClass:[NSNull class]])
            self.titleTextField.text = [captionDictionary objectForKey:@"text"];
    
    
    self.instragramMediaInfoDictionary = theDictionary;
    self.instagramPictureURLString = instagramProductImageURLString;
}

-(IBAction)backButtonHit
{
    [self.parentController vcDidHitBackWithController:self];
}

-(IBAction)previewButtonHit
{
    
    ProductCreateContainerObject *productCreateContainerObject = [[ProductCreateContainerObject alloc] init];
    
    int totalQuantity = 0;
    
    NSMutableArray *productsArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [self.sizeQuantityTableViewController.sizeSetValuesArray count]; i++)
    {
        
        int cellQuant = [[self.sizeQuantityTableViewController.sizeSetValuesArray objectAtIndex:i] intValue];
        if (cellQuant > 0)
        {
            
            ProductCreateObject *productCreateObject = [[ProductCreateObject alloc] init];
            productCreateObject.instagramPictureURLString = self.instagramPictureURLString;
            productCreateObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
            productCreateObject.title = self.titleTextField.text;
            productCreateObject.description = self.descriptionTextField.text;
            productCreateObject.retailValue = self.retailPriceTextField.text;
            productCreateObject.retailPrice = self.retailPriceTextField.text;
            productCreateObject.quantity = [NSString stringWithFormat:@"%d", cellQuant];
            productCreateObject.size = [self.sizeQuantityTableViewController.sizesArray objectAtIndex:i];
            productCreateObject.categoriesArray = [NSArray arrayWithArray:self.attributesArray];
            [productsArray addObject:productCreateObject];
            
            totalQuantity += [productCreateObject.quantity intValue];
        }
    }
    
    productCreateContainerObject.objectSizePermutationsArray = [[NSArray alloc] initWithArray:productsArray];
    
    if (totalQuantity > 0)
    {
        productCreateContainerObject.mainObject = [[ProductCreateObject alloc] init];
        productCreateContainerObject.mainObject.instagramPictureURLString = self.instagramPictureURLString;
        productCreateContainerObject.mainObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
        productCreateContainerObject.mainObject.title = self.titleTextField.text;
        productCreateContainerObject.mainObject.description = self.descriptionTextField.text;
        productCreateContainerObject.mainObject.retailValue = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.retailPrice = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.quantity = [NSString stringWithFormat:@"%d", totalQuantity];
        //    self.productCreateObject.shippingWeight = self.shippingTextField.text;
        
        
        [self.parentController previewButtonHitWithProductCreateObject:productCreateContainerObject];
        
    }
    else
    {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please select a size and/or quantity"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    }
  

    
    
    
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.retailPriceTextField resignFirstResponder];
    [self.instashopPriceTextField resignFirstResponder];
    
    
}


#pragma mark table view data source delegate methods








@end
