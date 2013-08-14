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
@synthesize descriptionView;
@synthesize pricesView;
@synthesize sizeQuantityView;


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
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGFloat whiteSpace = 8.0f;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    
    [self.view addSubview:self.containerScrollView];
    
    self.titleTextField.delegate = self;
    
    self.descriptionTextField.delegate = self;
    
    self.retailPriceTextField.delegate = self;
    
    self.instashopPriceTextField.delegate = self;
    
    self.attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.containerScrollView bringSubviewToFront:self.subCategoryContainerView];
        
    self.containerScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    self.containerScrollView.contentSize = CGSizeMake(screenWidth, self.theImageView.frame.size.height + self.descriptionView.frame.size.height + self.sizeQuantityView.frame.size.height + self.pricesView.frame.size.height + self.nextButton.frame.size.height + whiteSpace);
    
    
    self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:nil bundle:nil];

    self.categorySizeQuantityTableView.dataSource = self.sizeQuantityTableViewController;
    self.categorySizeQuantityTableView.delegate = self.sizeQuantityTableViewController;
    self.categorySizeQuantityTableView.alpha = 0;
    
    
}

- (IBAction) categoryButtonHit
{
    
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] initWithNibName:nil bundle:nil];
    categoriesViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    categoriesViewController.parentController = self;
    [self.navigationController pushViewController:categoriesViewController animated:YES];
    
    categoriesViewController.initialTableReference.frame = CGRectMake(0,20, categoriesViewController.initialTableReference.frame.size.width, categoriesViewController.initialTableReference.frame.size.height);
    
    [self resignResponders];
    
    
        
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
    
    
    

    self.sizeQuantityTableViewController.availableSizesArray = [[NSArray alloc] initWithArray:[[AttributesManager getSharedAttributesManager] getSizesWithArray:self.attributesArray]];
 
    if (self.categorySizeQuantityTableView.alpha == 0)
        [self addSizeButtonHit];
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
    
    for (id key in self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary)
    {
        NSDictionary *sizeObjectDictionary = [self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary objectForKey:key];
        int objectQuantity = [[sizeObjectDictionary objectForKey:QUANTITY_DICTIONARY_KEY] intValue];
        NSString *objectSize = [sizeObjectDictionary objectForKey:SIZE_DICTIONARY_KEY];

        if (objectQuantity > 0)
        {
            
            ProductCreateObject *productCreateObject = [[ProductCreateObject alloc] init];
            productCreateObject.instagramPictureURLString = self.instagramPictureURLString;
            productCreateObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
            productCreateObject.title = self.titleTextField.text;
            productCreateObject.description = self.descriptionTextField.text;
            productCreateObject.retailValue = self.retailPriceTextField.text;
            productCreateObject.retailPrice = self.retailPriceTextField.text;
            productCreateObject.quantity = [NSString stringWithFormat:@"%d", objectQuantity];
            if (objectSize != nil)
                productCreateObject.size = objectSize;
            productCreateObject.categoriesArray = [NSArray arrayWithArray:self.attributesArray];
            [productsArray addObject:productCreateObject];
            
            totalQuantity += objectQuantity;
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
  
    [self resignResponders];
}


#pragma mark table view data source delegate methods

- (IBAction) addSizeButtonHit
{
    NSLog(@"addSizeButtonHit, self.attributesArray: %@", self.attributesArray);
    if ([self.attributesArray count] == 0)
    {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Help"
                                                            message:@"Please select a category first"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        self.categorySizeQuantityTableView.alpha = 1;
        [self.sizeQuantityTableViewController ownerAddRowButtonHitWithTableView:categorySizeQuantityTableView];
    }

    
    NSLog(@"sizesArray: %@", [[NSArray alloc] initWithArray:[[AttributesManager getSharedAttributesManager] getSizesWithArray:self.attributesArray]]);
    
    
}

-(void)resignResponders
{
    
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.retailPriceTextField resignFirstResponder];
    [self.instashopPriceTextField resignFirstResponder];
    
    
}





@end
