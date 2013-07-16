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
#import "CategoriesPickerViewController.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

@synthesize parentController;
@synthesize productCreateObject;
@synthesize attributesArray;

@synthesize containerScrollView;
@synthesize subCategoryContainerView;
@synthesize sizeQuantityTableViewController;
@synthesize categorySizeQuantityTableView;
@synthesize theImageView;
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize selectedCategoriesLabel;
@synthesize retailPriceTextField;
@synthesize instashopPriceTextField;
@synthesize nextButton;
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
        
    // I SEEM TO HAVE MADE A MOCKERY OF THIS... NOT WORKING... TRYING TO SET CUSTOM BACK BUTTON... DAMN YOU APPLE!
    UIView *backCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backbutton"]];
    backImageView.frame = CGRectMake(0,0,44,44);
    [backCustomView addSubview:backImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,backCustomView.frame.size.width, backCustomView.frame.size.height);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [backCustomView addSubview:backButton];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backCustomView];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    
    //self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:116.0f/255.0f blue:93.0f/255.0f alpha:1];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    
    
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

    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.contentSize = CGSizeMake(0,self.subCategoryContainerView.frame.origin.y + self.subCategoryContainerView.frame.size.height - 100);
    
    
    self.attributesArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    self.subCategoryContainerView.backgroundColor = self.view.backgroundColor;
    self.categorySizeQuantityTableView.backgroundColor = self.view.backgroundColor;
    [self.containerScrollView bringSubviewToFront:self.subCategoryContainerView];
}

- (IBAction) categoryButtonHit
{
    for (int i = 0; i < [self.attributesArray count]; i++)
        [self.attributesArray setObject:@"" atIndexedSubscript:i];
    
    
    NSMutableArray *searchingKeysArray = [NSMutableArray arrayWithCapacity:0];
    
    int index = 0;
    while ([[self.attributesArray objectAtIndex:index] length] > 0)
    {
        [searchingKeysArray addObject:[self.attributesArray objectAtIndex:index]];
         index++;
    }

    int selectedIndexType = [searchingKeysArray count];
    NSArray *selectionArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:searchingKeysArray];

    if (selectionArray != nil)
    {
        
        CategoriesPickerViewController *categoriesPickerViewController = [[CategoriesPickerViewController alloc] initWithNibName:@"CategoriesPickerViewController" bundle:nil];
        categoriesPickerViewController.delegate = self;
        categoriesPickerViewController.type = selectedIndexType;
        categoriesPickerViewController.itemsArray = [[NSArray alloc] initWithArray:selectionArray];
        [self presentViewController:categoriesPickerViewController animated:YES completion:nil];
        
    }
    
 
}

-(void)categorySelected:(NSString *)selectedCategory withCategoriesPickerViewController:(CategoriesPickerViewController *)theController
{
    [self.attributesArray setObject:selectedCategory atIndexedSubscript:theController.type];
    
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    
    if ([[self.attributesArray objectAtIndex:0] length] > 0)
        [string appendString:[NSString stringWithFormat:@"%@", [self.attributesArray objectAtIndex:0]]];
    
    if ([[self.attributesArray objectAtIndex:1] length] > 0)
        [string appendString:[NSString stringWithFormat:@" > %@", [self.attributesArray objectAtIndex:1]]];

    if ([[self.attributesArray objectAtIndex:2] length] > 0)
        [string appendString:[NSString stringWithFormat:@" > %@", [self.attributesArray objectAtIndex:2]]];
    
    if ([string length] > 0)
        self.selectedCategoriesLabel.text = string;
    
    
    NSMutableArray *searchingKeysArray = [NSMutableArray arrayWithCapacity:0];
    
    int index = 0;
    while ([[self.attributesArray objectAtIndex:index] length] > 0)
    {
        [searchingKeysArray addObject:[self.attributesArray objectAtIndex:index]];
        index++;
    }
    
    int selectedIndexType = [searchingKeysArray count];
    
    NSArray *selectionArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:searchingKeysArray];
    if (selectionArray == nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        self.subCategoryContainerView.frame = CGRectMake(0, self.categorySizeQuantityTableView.frame.origin.y + self.categorySizeQuantityTableView.frame.size.height, self.subCategoryContainerView.frame.size.width, self.subCategoryContainerView.frame.size.height);
        [UIView commitAnimations];
        
        [self.containerScrollView bringSubviewToFront:self.subCategoryContainerView];
        
    }
    else
    {
        theController.type = selectedIndexType;
        theController.itemsArray = [NSArray arrayWithArray:selectionArray];
        [theController.thePickerView reloadAllComponents];
    }


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
    NSLog(@"instagramProductImageURLString: %@", instagramProductImageURLString);
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.theImageView];
    NSLog(@"self.theImageView: %@", self.theImageView);
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];

    NSLog(@"self.titleTextField: %@", self.titleTextField);
    if (captionDictionary != nil)
        if (![captionDictionary isKindOfClass:[NSNull class]])
            self.titleTextField.text = [captionDictionary objectForKey:@"text"];


    self.productCreateObject = [[ProductCreateObject alloc] init];
    self.productCreateObject.instragramMediaInfoDictionary = theDictionary;
    self.productCreateObject.instagramPictureURLString = instagramProductImageURLString;
}

-(IBAction)backButtonHit
{
    [self.parentController vcDidHitBackWithController:self];
}

-(IBAction)previewButtonHit
{        
    self.productCreateObject.caption = self.titleTextField.text;
    self.productCreateObject.description = self.descriptionTextField.text;
    self.productCreateObject.retailValue = self.retailPriceTextField.text;
    self.productCreateObject.retailPrice = self.retailPriceTextField.text;
//    self.productCreateObject.categoryAttribute = self.sizeColorTextField.text;
//    self.productCreateObject.quantity = self.quantityTextField.text;
//    self.productCreateObject.shippingWeight = self.shippingTextField.text;
    
    self.productCreateObject.productAttributesArray = [NSArray arrayWithArray:self.attributesArray];
    [self.parentController previewButtonHitWithProductCreateObject:self.productCreateObject];
    
    
    
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.retailPriceTextField resignFirstResponder];
    [self.instashopPriceTextField resignFirstResponder];    
}


#pragma mark table view data source delegate methods








@end
