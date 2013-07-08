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

@synthesize parentController, containerScrollView, productImageView;

@synthesize captionTextField;
@synthesize descriptionTextView;
@synthesize retailTextField;
@synthesize shippingTextField;
@synthesize priceTextField;
@synthesize sizeColorTextField;
@synthesize quantityTextField;

@synthesize productCreateObject;

@synthesize attributesArray;


@synthesize categoryButton;
@synthesize subcategoryButton;
@synthesize subSubCategoryButton;


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
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backbutton.png"]];
    backImageView.frame = CGRectMake(0,0,44,44);
    [backCustomView addSubview:backImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0,0,backCustomView.frame.size.width, backCustomView.frame.size.height);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [backCustomView addSubview:backButton];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backCustomView];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:116.0f/255.0f blue:93.0f/255.0f alpha:1];
    
    self.captionTextField.delegate = self;
    
    self.descriptionTextView.delegate = self;
    self.retailTextField.delegate = self;
    self.shippingTextField.delegate = self;
    self.priceTextField.delegate = self;
    self.sizeColorTextField.delegate = self;
    self.quantityTextField.delegate = self;
    
 
    float height = self.containerScrollView.frame.size.height;
    self.containerScrollView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.contentSize = CGSizeMake(0,height);
    
    
    self.attributesArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
}

- (void) loadButtonTitles
{
 
    if ([[self.attributesArray objectAtIndex:0] length] > 0)
        [self.categoryButton setTitle:[self.attributesArray objectAtIndex:0] forState:UIControlStateNormal];
    
    if ([[self.attributesArray objectAtIndex:1] length] > 0)
        [self.subcategoryButton setTitle:[self.attributesArray objectAtIndex:1] forState:UIControlStateNormal];
    
    if ([[self.attributesArray objectAtIndex:2] length] > 0)
        [self.subSubCategoryButton setTitle:[self.attributesArray objectAtIndex:2] forState:UIControlStateNormal];

    
}
- (IBAction) categoryButtonHit:(UIButton *)theButton
{
/*
    -(NSArray *)getTopCategories;
    -(NSArray *)getSubcategoriesFromTopCategory:(NSString *)topCategory;
    -(NSArray *)getAttributesFromTopCategory:(NSString *)topCategory fromSubcategory:(NSString *)subcategory;
*/
    
    int selectedIndexType = -1;
    NSArray *selectionArray = nil;
    
    if (theButton == categoryButton)
    {
        selectedIndexType = 0;
        selectionArray = [NSArray arrayWithArray:[[AttributesManager getSharedAttributesManager] getTopCategories]];
    }
    else if (theButton == subcategoryButton)
    {
        selectedIndexType = 1;
        if ([[self.attributesArray objectAtIndex:0] length] > 0)
            selectionArray = [NSArray arrayWithArray:[[AttributesManager getSharedAttributesManager] getSubcategoriesFromTopCategory:[self.attributesArray objectAtIndex:0]]];
    }

    else if (theButton == subSubCategoryButton)
    {
        selectedIndexType = 2;
        if ([[self.attributesArray objectAtIndex:0] length] > 0)
            if ([[self.attributesArray objectAtIndex:1] length] > 0)            
                selectionArray = [NSArray arrayWithArray:[[AttributesManager getSharedAttributesManager] getAttributesFromTopCategory:[self.attributesArray objectAtIndex:0] fromSubcategory:[self.attributesArray objectAtIndex:1]]];
    }

    
    if (selectionArray != nil)
    {
        
        CategoriesPickerViewController *categoriesPickerViewController = [[CategoriesPickerViewController alloc] initWithNibName:@"CategoriesPickerViewController" bundle:nil];
        categoriesPickerViewController.delegate = self;
        categoriesPickerViewController.type = selectedIndexType;
        categoriesPickerViewController.itemsArray = [[NSArray alloc] initWithArray:selectionArray];
        [self presentViewController:categoriesPickerViewController animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Please select preceeding category"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(void)categorySelected:(NSString *)selectedCategory withCategoriesPickerViewController:(CategoriesPickerViewController *)theController
{
    [self.attributesArray setObject:selectedCategory atIndexedSubscript:theController.type];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadButtonTitles];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    // +++ This is unnecessary if the scroll view is part of the main view in the xib +++ //
    
    //self.containerScrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    //[self.view addSubview:self.containerScrollView];
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 680);

    
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
    [self.parentController vcDidHitBackWithController:self];
}

-(IBAction)previewButtonHit
{        
    self.productCreateObject.caption = self.captionTextField.text;
    self.productCreateObject.description = self.descriptionTextView.text;
    self.productCreateObject.retailValue = self.retailTextField.text;
    self.productCreateObject.shippingWeight = self.shippingTextField.text;
    self.productCreateObject.price = self.priceTextField.text;
    self.productCreateObject.categoryAttribute = self.sizeColorTextField.text;
    self.productCreateObject.quantity = self.quantityTextField.text;
    self.productCreateObject.productAttributesArray = [NSArray arrayWithArray:self.attributesArray];
    [self.parentController previewButtonHitWithProductCreateObject:self.productCreateObject];
    
    
    
    [self.captionTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    [self.retailTextField resignFirstResponder];
    [self.shippingTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.sizeColorTextField resignFirstResponder];
    [self.quantityTextField resignFirstResponder];    

}



@end
