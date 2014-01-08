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
#import "NavBarTitleView.h"
@interface ProductPreviewViewController ()

@end

@implementation ProductPreviewViewController


@synthesize parentController;

@synthesize productCreateContainerObject;

@synthesize contentScrollView;
@synthesize productImageView;
@synthesize titleLabel;
@synthesize descriptionTextField;
@synthesize descriptionBackgroundImageView;
@synthesize bottomContentView;
@synthesize categoryTextField;
@synthesize categoryBackgroundImageView;
@synthesize listPriceValueTextField;
@synthesize shippingValueTextField;
@synthesize sellButton;
@synthesize sizeQuantityTableViewController;
@synthesize urlTextField;

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
    
    self.contentScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"PRODUCT INFO"]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.contentScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.bottomContentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:@"SizeQuantityTableViewController" bundle:nil];
    self.sizeQuantityTableViewController.isButtonsDisabled = YES;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.bottomContentView.frame.origin.y, self.view.frame.size.width, 0);
    self.sizeQuantityTableViewController.tableView.backgroundColor = [UIColor clearColor];
    [self.contentScrollView addSubview:self.sizeQuantityTableViewController.tableView];

    self.contentScrollView.contentSize = CGSizeMake(0, self.bottomContentView.frame.origin.y + self.bottomContentView.frame.size.height);
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}

- (IBAction) postButtonHit
{
    [self.parentController previewDoneButtonHit:self.productCreateContainerObject];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (descriptionTextField.contentSize.height > 44)
    {
        self.descriptionBackgroundImageView.frame = CGRectMake(self.descriptionBackgroundImageView.frame.origin.x, self.descriptionBackgroundImageView.frame.origin.y, self.descriptionBackgroundImageView.frame.size.width, descriptionTextField.contentSize.height);
        self.descriptionTextField.frame = CGRectMake(self.descriptionTextField.frame.origin.x, self.descriptionTextField.frame.origin.y, self.descriptionTextField.frame.size.width, descriptionTextField.contentSize.height);
    }
    else
    {
        self.descriptionBackgroundImageView.frame = CGRectMake(self.descriptionBackgroundImageView.frame.origin.x, self.descriptionBackgroundImageView.frame.origin.y, self.descriptionBackgroundImageView.frame.size.width, 44);
        self.descriptionTextField.frame = CGRectMake(self.descriptionTextField.frame.origin.x, self.descriptionTextField.frame.origin.y, self.descriptionTextField.frame.size.width, descriptionTextField.contentSize.height);
    }
    
    self.categoryBackgroundImageView.frame = CGRectMake(self.categoryBackgroundImageView.frame.origin.x, self.descriptionBackgroundImageView.frame.origin.y + self.descriptionBackgroundImageView.frame.size.height + 1, self.categoryBackgroundImageView.frame.size.width, self.categoryBackgroundImageView.frame.size.height);
    self.categoryTextField.frame = CGRectMake(self.categoryTextField.frame.origin.x,self.descriptionBackgroundImageView.frame.origin.y + self.descriptionBackgroundImageView.frame.size.height, self.categoryTextField.frame.size.width, self.categoryTextField.frame.size.height);
    
    
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.categoryTextField.frame.origin.y + self.categoryTextField.frame.size.height, self.sizeQuantityTableViewController.tableView.frame.size.width, [[self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary allKeys] count] * 44);
    
    self.bottomContentView.frame = CGRectMake(0, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height, self.bottomContentView.frame.size.width, self.bottomContentView.frame.size.height);
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.bottomContentView.frame.origin.y + self.bottomContentView.frame.size.height);
    
    [self.sizeQuantityTableViewController.tableView reloadData];
    
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject
{

    self.titleLabel.numberOfLines = 0;
    self.categoryTextField.enabled = NO;
    self.descriptionTextField.editable = NO;
    self.listPriceValueTextField.enabled = NO;

    
    self.productCreateContainerObject = theProductCreateContainerObject;
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateContainerObject.mainObject.instagramPictureURLString withImageView:self.productImageView];
    
    NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.productCreateContainerObject.mainObject.categoriesArray count]; i++)
    {
        [titleString appendString:[NSString stringWithFormat:@" %@", [self.productCreateContainerObject.mainObject.categoriesArray objectAtIndex:i]]];
        if (i != [self.productCreateContainerObject.mainObject.categoriesArray count] -1)
            [titleString appendString:@" >"];
        
    }
    
    self.categoryTextField.text = titleString;
    self.titleLabel.text = self.productCreateContainerObject.mainObject.title;
    self.descriptionTextField.text = self.productCreateContainerObject.mainObject.description;
    self.listPriceValueTextField.text = self.productCreateContainerObject.mainObject.listPrice;
    self.urlTextField.text = self.productCreateContainerObject.mainObject.referenceURLString;
    
    NSLog(@"theProductCreateContainerObject.tableViewCellSizeQuantityValueDictionary: %@", theProductCreateContainerObject.tableViewCellSizeQuantityValueDictionary);
    
    self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithDictionary:theProductCreateContainerObject.tableViewCellSizeQuantityValueDictionary];
    self.sizeQuantityTableViewController.rowShowCount = [[self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary allKeys] count];
    
    self.sizeQuantityTableViewController.tableView.scrollEnabled = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.bottomContentView.frame.origin.y + self.bottomContentView.frame.size.height);
}





@end
