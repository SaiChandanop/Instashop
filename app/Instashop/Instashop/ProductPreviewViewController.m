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

@synthesize theScrollView;
@synthesize productImageView;
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize bottomContentView;
@synthesize categoryTextField;
@synthesize listPriceValueTextField;
@synthesize shippingValueTextField;
@synthesize sellButton;


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
    
    self.theScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
}

- (IBAction) postButtonHit
{
    [self.parentController previewDoneButtonHit:self.productCreateContainerObject];
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject
{
    self.productCreateContainerObject = theProductCreateContainerObject;
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.productCreateContainerObject.mainObject.instagramPictureURLString withImageView:self.productImageView];
    
    self.titleTextField.text = self.productCreateContainerObject.mainObject.title;
    self.descriptionTextField.text = self.productCreateContainerObject.mainObject.description;
    self.listPriceValueTextField.text = self.productCreateContainerObject.mainObject.retailPrice;
    
    NSLog(@"self.titleLabel: %@", self.titleTextField);
    NSLog(@"self.descriptionTextField: %@", descriptionTextField);
    NSLog(@"self.listPriceValueTextField: %@", self.listPriceValueTextField);
    
    NSLog(@"self.productCreateContainerObject.mainObject.title: %@", self.productCreateContainerObject.mainObject.title);
    NSLog(@"self.productCreateContainerObject.mainObject.retailPrice: %@", self.productCreateContainerObject.mainObject.retailPrice);
    NSLog(@"self.productCreateContainerObject.mainObject.categoriesArray: %@", self.productCreateContainerObject.mainObject.categoriesArray);
    NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.productCreateContainerObject.mainObject.categoriesArray count]; i++)
    {
        [titleString appendString:[NSString stringWithFormat:@" %@", [self.productCreateContainerObject.mainObject.categoriesArray objectAtIndex:i]]];
        if (i != [self.productCreateContainerObject.mainObject.categoriesArray count] -1)
            [titleString appendString:@" >"];
        
    }
    self.categoryTextField.text = titleString;
    
    NSLog(@"titleString: %@", titleString);

    self.theScrollView.contentSize = CGSizeMake(0, 0);// self.sellButton.frame.origin.y + self.sellButton.frame.size.height);
    
    NSLog(@"self.theScrollView: %@", theScrollView);
}





@end
