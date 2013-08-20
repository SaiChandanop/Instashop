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
@synthesize theImageView;
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize selectedCategoriesLabel;
@synthesize retailPriceTextField;
@synthesize instashopPriceTextField;
@synthesize nextButton;
@synthesize addSizeButton;
@synthesize nextButtonContainerView;
@synthesize retailPriceLabel;
@synthesize instashopPriceLabel;
@synthesize descriptionView;
@synthesize pricesView;
@synthesize sizeQuantityView;
@synthesize originalPriceViewRect;

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
    self.descriptionTextField.delegate = self;
    self.retailPriceTextField.delegate = self;
    self.instashopPriceTextField.delegate = self;
    
    self.attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.containerScrollView bringSubviewToFront:self.subCategoryContainerView];
    
    
    self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:@"SizeQuantityTableViewController" bundle:nil];
    self.sizeQuantityTableViewController.productDetailsViewController = self;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.pricesView.frame.origin.y, self.view.frame.size.width, 0);
    [self.containerScrollView  insertSubview:self.sizeQuantityTableViewController.tableView belowSubview:self.pricesView];
    
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.pricesView.frame.origin.y + self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 29);
    
    self.originalPriceViewRect = self.pricesView.frame;
    
    self.addSizeButton.alpha = 0;
    
    
    [self.titleTextField setValue:[UIColor lightGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];

    [self.descriptionTextField setValue:[UIColor lightGrayColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.selectedCategoriesLabel setValue:[UIColor lightGrayColor]
                             forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.instashopPriceTextField setValue:[UIColor lightGrayColor]
                             forKeyPath:@"_placeholderLabel.textColor"];

    [self.retailPriceTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];

    
}



- (IBAction) categoryButtonHit
{
    
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] initWithNibName:nil bundle:nil];
    categoriesViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    categoriesViewController.parentController = self;
    [self.navigationController pushViewController:categoriesViewController animated:YES];
    
    categoriesViewController.initialTableReference.frame = CGRectMake(0,1, categoriesViewController.initialTableReference.frame.size.width, categoriesViewController.initialTableReference.frame.size.height);
    
    [self resignResponders];
    
    
        
}

-(void)categorySelectionCompleteWithArray:(NSArray *)theArray
{
    
    self.addSizeButton.frame = CGRectMake(self.addSizeButton.frame.origin.x, self.addSizeButton.frame.origin.y, self.addSizeButton.frame.size.width, 44);
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
    
    
    self.sizeQuantityTableViewController.rowShowCount = 0;
    self.sizeQuantityTableViewController.availableSizesArray = [[NSArray alloc] initWithArray:[[AttributesManager getSharedAttributesManager] getSizesWithArray:self.attributesArray]];
    self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self.sizeQuantityTableViewController.tableView reloadData];

    self.pricesView.frame = self.originalPriceViewRect;

    [self addSizeButtonHit];
    

}



- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    
    NSString *instagramProductImageURLString = [startResultionDictionary objectForKey:@"url"];
 
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.theImageView];
 
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];
    
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
    productCreateContainerObject.tableViewCellSizeQuantityValueDictionary = self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary;
    if (totalQuantity > 0)
    {
        productCreateContainerObject.mainObject = [[ProductCreateObject alloc] init];
        productCreateContainerObject.mainObject.instagramPictureURLString = self.instagramPictureURLString;
        productCreateContainerObject.mainObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
        productCreateContainerObject.mainObject.title = self.titleTextField.text;
        productCreateContainerObject.mainObject.description = self.descriptionTextField.text;
        productCreateContainerObject.mainObject.retailValue = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.retailPrice = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.listPrice = self.instashopPriceTextField.text;
        productCreateContainerObject.mainObject.quantity = [NSString stringWithFormat:@"%d", totalQuantity];
        productCreateContainerObject.mainObject.categoriesArray = [[NSArray alloc] initWithArray:self.attributesArray];
        //    self.productCreateObject.shippingWeight = self.shippingTextField.text;
        
        
        [self.parentController previewButtonHitWithProductCreateObject:productCreateContainerObject];
        
    }
    else
    {
        if ([self.selectedCategoriesLabel.text length] == 0)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please Select a category"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alertView show];
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
        
        
    }
  
    [self resignResponders];
}


#pragma mark table view data source delegate methods

-(void)updateLayout
{
    float extendHeight = 42;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.sizeQuantityTableViewController.tableView.frame.origin.y, self.sizeQuantityTableViewController.tableView.frame.size.width, extendHeight * self.sizeQuantityTableViewController.rowShowCount);
    
    
    if (self.sizeQuantityTableViewController.rowShowCount > 0 && [[self.sizeQuantityTableViewController getRemainingAvailableSizesArray] count] == 0)
    {
        NSLog(@"HERE");
         self.addSizeButton.frame = CGRectMake(self.addSizeButton.frame.origin.x, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height, self.sizeQuantityTableViewController.tableView.frame.size.width, 0);
        self.addSizeButton.alpha = 0;
    }
    else
    {
        NSLog(@"HERE2");
        self.addSizeButton.alpha = 1;
        self.addSizeButton.frame = CGRectMake(self.addSizeButton.frame.origin.x, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height, self.sizeQuantityTableViewController.tableView.frame.size.width, 44);
    }
    
    self.pricesView.frame = CGRectMake(self.pricesView.frame.origin.x, self.addSizeButton.frame.origin.y + self.addSizeButton.frame.size.height, self.pricesView.frame.size.width, self.pricesView.frame.size.height);
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.pricesView.frame.origin.y + self.nextButton.frame.origin.y + self.nextButton.frame.size.height  + 29);

    
}
- (IBAction) addSizeButtonHit
{
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
        
        
        [self.addSizeButton setTitle:@"Add Another Size" forState:UIControlStateNormal];
        
        [self.sizeQuantityTableViewController ownerAddRowButtonHitWithTableView:self.sizeQuantityTableViewController.tableView];
        [self updateLayout];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.retailPriceTextField || textField == self.instashopPriceTextField)
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        textField.text = [NSString stringWithFormat:@"$%@%@", textField.text, string];
        return NO;
    }
    else
        return YES;
    
    
}

-(void)resignResponders
{
    
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.retailPriceTextField resignFirstResponder];
    [self.instashopPriceTextField resignFirstResponder];
}





@end
