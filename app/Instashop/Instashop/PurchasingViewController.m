//
//  PurchasingViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingViewController.h"
#import "ImageAPIHandler.h"
#import "FeedViewController.h"
#import "AppDelegate.h"
#import "STPCard.h"
#import "StripeAuthenticationHandler.h"
#import "ProductAPIHandler.h"
#import "PurchasingAddressViewController.h"
#import "SellersAPIHandler.h"
#import "SizePickerViewViewController.h"
#import "ProfileViewController.h"
@interface PurchasingViewController ()

@property (nonatomic, retain) NSDictionary *requestedProductObject;

@end

@implementation PurchasingViewController

@synthesize heartImageView;
@synthesize sizePickerViewViewController;
@synthesize requestingProductID;
@synthesize requestedPostmasterDictionary;
@synthesize parentController;
@synthesize contentScrollView;
@synthesize categoryLabel;
@synthesize descriptionContainerView;
@synthesize requestedProductObject;
@synthesize imageView, titleLabel, sellerLabel, likesLabel, descriptionTextView, listPriceLabel, retailPriceLabel, numberAvailableLabel, sellerProfileImageView;
@synthesize bottomView;
@synthesize sizeSelectedIndex;
@synthesize purchaseButton;
@synthesize likesArray;

@synthesize actionSheet;
@synthesize quantityButton;
@synthesize sizeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    self.descriptionContainerView.frame = CGRectMake(self.descriptionContainerView.frame.origin.x, self.descriptionContainerView.frame.origin.y, self.descriptionContainerView.frame.size.width, self.descriptionTextView.contentSize.height + 30);
    self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.contentSize.height);
   
    self.contentScrollView.contentSize = CGSizeMake(0, self.descriptionContainerView.frame.origin.y + self.descriptionContainerView.frame.size.height);

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self];
    
    self.sizeSelectedIndex = 0;
    self.descriptionTextView.text = @"";
    
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarISLogo.png"]];
    self.navigationItem.titleView = theImageView;
    
    self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
    
    
    self.sizeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.sizeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.quantityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.quantityButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}


- (void) loadContentViews
{
    [self.sellerProfileImageView beginAnimations];
    

    NSLog(@"self.requestedProductObject: %@", self.requestedProductObject);
        
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.requestedProductObject objectForKey:@"owner_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];

    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 9; i++)
    {
        NSString *attributeKeyString = [NSString stringWithFormat:@"attribute_%d", i];
        NSString *attributeValue = [self.requestedProductObject objectForKey:attributeKeyString];
        
        if (![attributeValue isKindOfClass:[NSNull class]])
            if ([attributeValue length] > 0 != NSOrderedSame)
                [attributesArray addObject:attributeValue];
    }
    
    NSMutableString *categoryString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [attributesArray count]; i++)
    {
        [categoryString appendString:[attributesArray objectAtIndex:i]];
        if (i != [attributesArray count] -1)
            [categoryString appendString:@" > "];
    }

    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedProductObject objectForKey:@"products_url"] withImageView:self.imageView];
    
    self.titleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [self.requestedProductObject objectForKey:@"products_description"];
    self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width,  self.descriptionTextView.contentSize.height);

    
    
    
    
    self.numberAvailableLabel.text = [NSString stringWithFormat:@"%d left", [[self.requestedProductObject objectForKey:@"products_quantity"] intValue]];

    self.retailPriceLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
    if (![[self.requestedProductObject objectForKey:@"products_list_price"] isKindOfClass:[NSNull class]])
    {
        NSString *listPriceString =[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_list_price"] floatValue]]];
        NSAttributedString *strikethroughString = [[NSAttributedString alloc] initWithString:listPriceString
                                                                        attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        
        
        self.listPriceLabel.attributedText = strikethroughString;
        
    }
    
    self.categoryLabel.text = categoryString;
    
    
    
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];    
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
        {
            //Joel set your button style here
            self.sizeButton.enabled = NO;
            
        }



    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - self.bottomView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    [self.view bringSubviewToFront:self.bottomView];
    
    
    //[self.parentController rowValueSelectedWithIndexPath:self.theIndexPath withKey:self.theController.typeKeyString withValue:[self.theController.itemsArray objectAtIndex:self.theController.selectedRow]];
    [self.quantityButton setTitle:@"1" forState:UIControlStateNormal];
    
    
    self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.contentSize.height);
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.descriptionContainerView.frame.origin.y + self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 8);
    
    

}

-(void)imageRequestFinished:(UIImageView *)referenceImageView
{
    
//    if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
//        [(ISAsynchImageView *)referenceImageView ceaseAnimations];
    
    
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
        
    if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *metaDictionary = [result objectForKey:@"meta"];
        if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
        }
    }
    else if ([request.url rangeOfString:@"likes"].length > 0)
    {
        if ([request.httpMethod compare:@"POST"] == NSOrderedSame)
        {
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
            [appDelegate.instagram requestWithParams:params delegate:self];
            
            
        }
        else if ([request.httpMethod compare:@"DELETE"] == NSOrderedSame)
        {            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
            [appDelegate.instagram requestWithParams:params delegate:self];
            
            
        }
        else
        {
            NSArray *dataArray = [result objectForKey:@"data"];
            self.likesArray = [[NSArray alloc] initWithArray:dataArray];
            self.likesLabel.text = [NSString stringWithFormat:@"%d likes", [dataArray count]];
            
            if ([self likesArrayContainsSelf])
                self.heartImageView.image = [UIImage imageNamed:@"heart_red.png"];
            else
                self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
        }
    }
    
    self.likesLabel.textColor = [UIColor whiteColor];
    self.likesLabel.alpha = 1;
}



-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    if ([theArray count] > 0)
        self.requestedProductObject = [theArray objectAtIndex:0];
    
    [self loadContentViews];
}


-(IBAction)buyButtonHit
{
     NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL isSingleSize = NO;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            isSingleSize = YES;
    
    
    if (!isSingleSize &&  [[self.sizeButton titleForState:UIControlStateNormal] compare:@"Size"] == NSOrderedSame)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select a size and or quantity"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
        NSDictionary *productCategoryObject = [sizeQuantityArray objectAtIndex:self.sizeSelectedIndex];
        
        PurchasingAddressViewController *purchasingAddressViewController = [[PurchasingAddressViewController alloc] initWithNibName:@"PurchasingAddressViewController" bundle:nil];
        purchasingAddressViewController.view.frame = CGRectMake(purchasingAddressViewController.view.frame.origin.x, purchasingAddressViewController.view.frame.origin.y, purchasingAddressViewController.view.frame.size.width, purchasingAddressViewController.view.frame.size.height);
        purchasingAddressViewController.productCategoryDictionary = productCategoryObject;
        purchasingAddressViewController.shippingCompleteDelegate = self;
        [self.navigationController pushViewController:purchasingAddressViewController animated:YES];
        [purchasingAddressViewController loadWithSizeSelection:[self.sizeButton titleForState:UIControlStateNormal] withQuantitySelection:[self.quantityButton titleForState:UIControlStateNormal] withProductImage:self.imageView.image];
        [purchasingAddressViewController loadWithRequestedProductObject:self.requestedProductObject];
        
    }
    
}






-(IBAction)sizeButtonHit
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL proceed = YES;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            proceed = NO;
    
    if (proceed)
    {
        NSMutableArray *sizesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [sizeQuantityArray count]; i++)
        {
            NSDictionary *obj = [sizeQuantityArray objectAtIndex:i];
            [sizesArray addObject:[obj objectForKey:@"size"]];
        }
        
        self.sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
        self.sizePickerViewViewController.type = 0;
        self.sizePickerViewViewController.itemsArray = [NSMutableArray arrayWithArray:sizesArray];
        
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.autoresizesSubviews = NO;
        self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self.actionSheet addSubview:self.sizePickerViewViewController.view];
        
        [self.actionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
        [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
        
        [self.sizePickerViewViewController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.sizePickerViewViewController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No Size selection necessary"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

-(IBAction)quantityButtonHit
{
    NSArray *sizeQuantityArray = [self.requestedProductObject objectForKey:@"size_quantity"];
    
    BOOL isSingleSize = NO;
    if ([sizeQuantityArray count] == 1)
        if ([(NSString *)[[sizeQuantityArray objectAtIndex:0] objectForKey:@"size"] compare:@"(null)"] == NSOrderedSame)
            isSingleSize = YES;
    
    NSMutableArray *quantityArray = nil;
    
    
    if (isSingleSize)
    {
        quantityArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 1; i <= [[[sizeQuantityArray objectAtIndex:0] objectForKey:@"quantity"] intValue]; i++)
            [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
    }

    
    else if (self.sizeSelectedIndex >= 0)
    {
        quantityArray = [NSMutableArray arrayWithCapacity:0];
        int quantity = [[[sizeQuantityArray objectAtIndex:self.sizeSelectedIndex] objectForKey:@"quantity"] intValue];
        for (int i = 1; i <= quantity; i++)
            [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
        
    }
    
    
    
    
    if (quantityArray != nil || isSingleSize)
    {
        
        self.sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
        self.sizePickerViewViewController.type = 1;
        self.sizePickerViewViewController.itemsArray = [NSMutableArray arrayWithArray:quantityArray];
        //[self presentViewController:self.sizePickerViewViewController animated:YES completion:nil];
        
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.autoresizesSubviews = NO;
        self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self.actionSheet addSubview:self.sizePickerViewViewController.view];
        
        [self.actionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
        [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
        
        [self.sizePickerViewViewController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.sizePickerViewViewController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
        
        

    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select a size"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

-(void)pickerCancelButtonHit
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)pickerSaveButtonHit
{
    if (self.actionSheet)
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *titleItem = [self.sizePickerViewViewController.itemsArray objectAtIndex:[self.sizePickerViewViewController.thePickerView selectedRowInComponent:0]];
    if (self.sizePickerViewViewController.type == 0)
    {
        [self.sizeButton setTitle:titleItem forState:UIControlStateNormal];
        self.sizeSelectedIndex = [self.sizePickerViewViewController.thePickerView selectedRowInComponent:0];
    }
    else
    {
        if (self.sizeSelectedIndex == -1)
            self.sizeSelectedIndex = 0;
        
        [self.quantityButton setTitle:titleItem forState:UIControlStateNormal];
        
    }
}




-(IBAction)likeButtonHit
{
    
    NSLog(@"likeButtonHit");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
          
    if ([self likesArrayContainsSelf])
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
        [appDelegate.instagram delRequestWithParams:params delegate:self];
    }
    else
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@/likes", [self.requestedProductObject objectForKey:@"products_instagram_id"]], @"method", nil];
        [appDelegate.instagram postRequestWithParams:params delegate:self];        
    }

}

-(BOOL)likesArrayContainsSelf
{
    BOOL sameID = NO;
    for (int i = 0; i < [self.likesArray count]; i++)
    {
        NSDictionary *likeDictionary = [self.likesArray objectAtIndex:i];
        
        NSString *likeID = [likeDictionary objectForKey:@"id"];
        
        if ([likeID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
            sameID = YES;
        
    }
    
    return sameID;
}



- (IBAction) profileButtonHit
{
    if (self.requestedProductObject != nil)
        if ([self.requestedProductObject objectForKey:@"owner_instagram_id"] != nil)
        {
            ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            profileViewController.profileInstagramID = [self.requestedProductObject objectForKey:@"owner_instagram_id"];
            [self.navigationController pushViewController:profileViewController animated:YES];
        }    
}



@end
