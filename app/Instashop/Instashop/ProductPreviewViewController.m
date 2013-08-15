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

@synthesize contentScrollView;
@synthesize productImageView;
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize bottomContentView;
@synthesize categoryTextField;
@synthesize listPriceValueTextField;
@synthesize shippingValueTextField;
@synthesize sellButton;
@synthesize sizeQuantityTableViewController;


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
    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonHit)];
  //  self.navigationItem.rightBarButtonItem = doneButton;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.contentScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.bottomContentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:@"SizeQuantityTableViewController" bundle:nil];
    self.sizeQuantityTableViewController.isButtonsDisabled = YES;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.bottomContentView.frame.origin.y, self.view.frame.size.width, 0);
    self.sizeQuantityTableViewController.tableView.backgroundColor = [UIColor redColor];
    [self.contentScrollView addSubview:self.sizeQuantityTableViewController.tableView];

    
    
}

- (IBAction) postButtonHit
{
    [self.parentController previewDoneButtonHit:self.productCreateContainerObject];
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject
{
//    self.titleTextField.isEnabled = NO;
    self.titleTextField.enabled = NO;
    self.categoryTextField.enabled = NO;
    self.descriptionTextField.editable = NO;
    self.
    
    self.productCreateContainerObject = theProductCreateContainerObject;
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateContainerObject.mainObject.instagramPictureURLString withImageView:self.productImageView];
    
    self.titleTextField.text = self.productCreateContainerObject.mainObject.title;
    self.descriptionTextField.text = self.productCreateContainerObject.mainObject.description;
    self.listPriceValueTextField.text = self.productCreateContainerObject.mainObject.retailPrice;
    
    NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.productCreateContainerObject.mainObject.categoriesArray count]; i++)
    {
        [titleString appendString:[NSString stringWithFormat:@" %@", [self.productCreateContainerObject.mainObject.categoriesArray objectAtIndex:i]]];
        if (i != [self.productCreateContainerObject.mainObject.categoriesArray count] -1)
            [titleString appendString:@" >"];
        
    }

    self.categoryTextField.text = titleString;
    
    
    self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithDictionary:theProductCreateContainerObject.tableViewCellSizeQuantityValueDictionary];
    self.sizeQuantityTableViewController.rowShowCount = [[self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary allKeys] count] * 44;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.sizeQuantityTableViewController.tableView.frame.origin.y, self.sizeQuantityTableViewController.tableView.frame.size.width, [[self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary allKeys] count] * 44);
    [self.sizeQuantityTableViewController.tableView reloadData];
    
    self.bottomContentView.frame = CGRectMake(0, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height, self.bottomContentView.frame.size.width, self.bottomContentView.frame.size.height);
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.bottomContentView.frame.origin.y +  self.sellButton.frame.origin.y + self.sellButton.frame.size.height);
    
}





@end
