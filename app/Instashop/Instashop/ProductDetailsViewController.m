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
#import "NavBarTitleView.h"
#import "AppDelegate.h"
#import "ProductAPIHandler.h"
#import "CIALBrowserViewController.h"
#import "SocialManager.h"
#import "NotificationsAPIHandler.h"
#import "InstagramUserObject.h"
#import "CreateProductAPIHandler.h"
#import "SellersAPIHandler.h"
#import "Flurry.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

@synthesize instashopPriceContainerView;
@synthesize retailPriceContainerView;
@synthesize categoriesContainerView;
@synthesize descriptionContainerView;
@synthesize instagramPictureURLString;
@synthesize instragramMediaInfoDictionary;
@synthesize sizeQuantityTableViewController;
@synthesize parentController;
@synthesize editingProductID;
@synthesize attributesArray;
@synthesize containerScrollView;
@synthesize theImageView;
@synthesize titleTextView;
@synthesize descriptionTextView;
@synthesize selectedCategoriesLabel;
@synthesize retailPriceTextField;
@synthesize instashopPriceTextField;
@synthesize addSizeButton;
@synthesize pricesView;
@synthesize sizeQuantityView;
@synthesize originalPriceViewRect;
@synthesize editingProductObject;
@synthesize urlLabel;
@synthesize urlButton;
@synthesize urlContainerView;
@synthesize socialButtonContainerView;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize browserViewController;
@synthesize nextButton;
@synthesize isEdit;
@synthesize twitterAccountsArray;
@synthesize jkProgressView;
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
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"PRODUCT INFO"]];
    
    self.containerScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.containerScrollView];
    
    
    
    self.descriptionTextView.delegate = self;
    self.retailPriceTextField.delegate = self;
    self.instashopPriceTextField.delegate = self;
    
    self.attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.sizeQuantityTableViewController = [[SizeQuantityTableViewController alloc] initWithNibName:@"SizeQuantityTableViewController" bundle:nil];
    self.sizeQuantityTableViewController.productDetailsViewController = self;
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.pricesView.frame.origin.y, self.view.frame.size.width, 0);
    [self.containerScrollView  insertSubview:self.sizeQuantityTableViewController.tableView belowSubview:self.pricesView];
    
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.nextButton.frame.origin.y + self.nextButton.frame.size.height);
    
    self.originalPriceViewRect = self.pricesView.frame;
    
    self.addSizeButton.alpha = 0;
    
    
    [self.selectedCategoriesLabel setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.instashopPriceTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.retailPriceTextField setValue:[UIColor lightGrayColor]
                             forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    
    self.facebookButton.selected = NO;
    self.twitterButton.selected = NO;
    
    self.addSizeButton.alpha = 0;
    [self.addSizeButton removeFromSuperview];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    if (self.isEdit)
    {
        UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = customBackButton;
    }
    [self setDoneButtonState];
    
    
    [self.descriptionTextView setReturnKeyType:UIReturnKeyDone];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
}

-(void)setDoneButtonState
{
    if ([self validateContentWithDoAlert:NO])
        [self.nextButton setTitle:@"POST PRODUCT" forState:UIControlStateNormal];
    else
        [self.nextButton setTitle:@"POST PRODUCT" forState:UIControlStateNormal];
    
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadWithProductObject:(NSDictionary *)productObject withMediaInstagramID:(NSString *)mediaInstagramID
{
    
    self.editingProductObject = [[NSDictionary alloc] initWithDictionary:productObject];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@", mediaInstagramID], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    NSLog(@"productObject: %@", productObject);
    
    
    //    self.titleTextView.text = [productObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [productObject objectForKey:@"products_description"];
    
    if ([self.descriptionTextView.text compare:@"Description"] != NSOrderedSame)
        self.descriptionTextView.textColor = [UIColor whiteColor];
    
    self.retailPriceTextField.text = [productObject objectForKey:@"products_price"];
    self.instashopPriceTextField.text = [productObject objectForKey:@"products_list_price"];
    self.editingProductID = [productObject objectForKey:@"product_id"];
    
    NSMutableArray *theCategoriesArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 1; i < 10; i++)
    {
        NSString *attributeString = [NSString stringWithFormat:@"attribute_%d", i];
        NSString *attributeValue = [productObject objectForKey:attributeString];
        
        if (![attributeValue isKindOfClass:[NSNull class]])
            if ([attributeValue length] > 0)
                [theCategoriesArray addObject:attributeValue];
        
        
    }
    
    [self categorySelectionCompleteWithArray:theCategoriesArray];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSArray *sizeQuantityArray = [productObject objectForKey:@"size_quantity"];
    for (int i = 0; i < [sizeQuantityArray count]; i++)
    {
        NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionaryWithDictionary:[sizeQuantityArray objectAtIndex:i]];
        
        if ([itemDictionary objectForKey:@"size"] != nil)
            [itemDictionary setObject:[itemDictionary objectForKey:@"size"] forKey:SIZE_DICTIONARY_KEY];
        
        if ([itemDictionary objectForKey:@"quantity"] != nil)
            [itemDictionary setObject:[itemDictionary objectForKey:@"quantity"] forKey:QUANTITY_DICTIONARY_KEY];
        
        [dict setObject:itemDictionary forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.sizeQuantityTableViewController.rowShowCount = [[dict allKeys] count];
    [self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary addEntriesFromDictionary:dict];
    
    NSLog(@"cellSizeQuantityValueDictionary: %@", self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary);
    [self.sizeQuantityTableViewController.tableView reloadData];
    
    if ([productObject objectForKey:@"products_external_url"] != nil)
    {
        self.urlLabel.text = [productObject objectForKey:@"products_external_url"];
        [self.nextButton setTitle:@"UPDATE PRODUCT" forState:UIControlStateNormal];
        
    }
    //    [self updateLayout];
    
    
    /*
     UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
     deleteButton.frame = CGRectMake(0,0,80, 44);
     [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
     deleteButton.backgroundColor = [UIColor clearColor];
     [deleteButton addTarget:self action:@selector(deleteButtonHit) forControlEvents:UIControlEventTouchUpInside];
     
     
     UIBarButtonItem *deletBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
     self.navigationItem.rightBarButtonItem = deletBarButtonItem;
     */
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

-(void)deleteButtonHit
{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Wait"
                                                        message:@"Are you sure you want to delete?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [ProductAPIHandler deleteProductWithProductID:[self.editingProductObject objectForKey:@"product_id"]];
    }
    
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
    
    NSDictionary *theDictionary = [result objectForKey:@"data"];
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    NSString *instagramProductImageURLString = [startResultionDictionary objectForKey:@"url"];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.theImageView];
    self.instragramMediaInfoDictionary = theDictionary;
    self.instagramPictureURLString = instagramProductImageURLString;
    
    //    NSLog(@"theDictionary: %@", theDictionary);
    
}

- (IBAction) categoryButtonHit
{
    
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] initWithNibName:nil bundle:nil];
    categoriesViewController.categoriesType = CATEGORIES_TYPE_PRODUCT;
    categoriesViewController.potentialCategoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:[NSArray array]];
    categoriesViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    categoriesViewController.parentController = self;
    [self.navigationController pushViewController:categoriesViewController animated:YES];
    
    categoriesViewController.initialTableReference.frame = CGRectMake(0,1, categoriesViewController.initialTableReference.frame.size.width, categoriesViewController.initialTableReference.frame.size.height);
    
    [self resignResponders];
    
    [self.descriptionTextView resignFirstResponder];
    
    
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
    
    if (!self.isEdit)
        [self setDoneButtonState];
    
}



- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{
    //   NSLog(@"theDictionary: %@", theDictionary);
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    
    NSString *instagramProductImageURLString = [startResultionDictionary objectForKey:@"url"];
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:instagramProductImageURLString withImageView:self.theImageView];
    
    NSDictionary *captionDictionary = [theDictionary objectForKey:@"caption"];
    
    if (captionDictionary != nil)
        if (![captionDictionary isKindOfClass:[NSNull class]])
            self.descriptionTextView.text = [captionDictionary objectForKey:@"text"];
    //self.titleTextView.text = [captionDictionary objectForKey:@"text"];
    
    if ([self.descriptionTextView.text compare:@"Description"] != NSOrderedSame)
        self.descriptionTextView.textColor = [UIColor whiteColor];
    
    
    self.instragramMediaInfoDictionary = theDictionary;
    self.instagramPictureURLString = instagramProductImageURLString;
    
    [self resizeWithTextView:self.descriptionTextView];
}


-(void) runSocialCalls
{
    if (self.twitterButton.selected)
    {
        NSString *twitterString = [NSString stringWithFormat:@"%@ via %@ %@", self.descriptionTextView.text, @"@shopsyapp", self.urlLabel.text];
        [SocialManager postToTwitterWithString:twitterString];
        
        [NotificationsAPIHandler createUserSocialNotificationWithProductID:[self.editingProductObject objectForKey:@"product_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID withSocialType:@"twitter"];
    }
    
    if (self.facebookButton.selected)
    {
        NSString *facebookString = [NSString stringWithFormat:@"%@ via %@ %@", self.descriptionTextView.text, @"@shopsy", self.urlLabel.text];
        [SocialManager postToFacebookWithString:facebookString withImage:nil];
        
        [NotificationsAPIHandler createUserSocialNotificationWithProductID:[self.editingProductObject objectForKey:@"product_id"] withInstagramID:[InstagramUserObject getStoredUserObject].userID withSocialType:@"facebook"];
    }
}

-(BOOL)validateContentWithDoAlert:(BOOL)doAlert
{
    BOOL retVal = NO;
    
    NSLog(@"urlLabel.text: %@", self.urlLabel.text);
    NSLog(@"attributesArray: %@", self.attributesArray);
    
    if ([self.urlLabel.text length] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please add a Purchase Link where this product is for sale."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        if (doAlert)
            [alertView show];
    }
    else if (self.attributesArray.count > 0)
    {
        retVal = YES;
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please Select a category"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        if (doAlert)
            [alertView show];
    }
    
    [self resignResponders];
    
    return retVal;
}


-(IBAction)previewButtonHit
{
    ProductCreateContainerObject *productCreateContainerObject = [[ProductCreateContainerObject alloc] init];
    
    int totalQuantity = 0;
    if (self.isEdit)
    {
        /*    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"is edit"
         message:@""
         delegate:nil
         cancelButtonTitle:@"Ok"
         otherButtonTitles:nil];
         [alertView show];
         */
        NSLog(@"edit, self.urlLabel.text: %@", self.urlLabel.text);
        NSLog(@"attributesArray, %@", self.attributesArray);
        
        productCreateContainerObject.mainObject = [[ProductCreateObject alloc] init];
        productCreateContainerObject.mainObject.instagramPictureURLString = self.instagramPictureURLString;
        productCreateContainerObject.mainObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
        productCreateContainerObject.mainObject.title = self.titleTextView.text;
        productCreateContainerObject.mainObject.description = self.descriptionTextView.text;
        productCreateContainerObject.mainObject.retailValue = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.retailPrice = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.listPrice = self.instashopPriceTextField.text;
        productCreateContainerObject.mainObject.quantity = [NSString stringWithFormat:@"%d", totalQuantity];
        productCreateContainerObject.mainObject.categoriesArray = [[NSArray alloc] initWithArray:self.attributesArray];
        productCreateContainerObject.mainObject.editingReferenceID = self.editingProductID;
        productCreateContainerObject.mainObject.referenceURLString = self.urlLabel.text;
        
        
        
        
//        self.jkProgressView = [JKProgressView presentProgressViewInView:[AppRootViewController sharedRootViewController].view withText:@"Editing Product"];
        
        
        [ProductAPIHandler editProductCreateObjectWithDelegate:self withProductID:[self.editingProductObject objectForKey:@"product_id"] withProductCreateObject:productCreateContainerObject];
        
    }
    
    else if ([self validateContentWithDoAlert:YES])
    {
        productCreateContainerObject.mainObject = [[ProductCreateObject alloc] init];
        productCreateContainerObject.mainObject.instagramPictureURLString = self.instagramPictureURLString;
        productCreateContainerObject.mainObject.instragramMediaInfoDictionary = self.instragramMediaInfoDictionary;
        productCreateContainerObject.mainObject.title = self.titleTextView.text;
        productCreateContainerObject.mainObject.description = self.descriptionTextView.text;
        productCreateContainerObject.mainObject.retailValue = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.retailPrice = self.retailPriceTextField.text;
        productCreateContainerObject.mainObject.listPrice = self.instashopPriceTextField.text;
        productCreateContainerObject.mainObject.quantity = [NSString stringWithFormat:@"%d", totalQuantity];
        productCreateContainerObject.mainObject.categoriesArray = [[NSArray alloc] initWithArray:self.attributesArray];
        productCreateContainerObject.mainObject.editingReferenceID = self.editingProductID;
        productCreateContainerObject.mainObject.referenceURLString = self.urlLabel.text;
        //    self.productCreateObject.shippingWeight = self.shippingTextField.text;
        
        [self runSocialCalls];
        
        //[self.parentController previewButtonHitWithProductCreateObject:productCreateContainerObject];
        
        
//        self.jkProgressView = [JKProgressView presentProgressViewInView:[AppRootViewController sharedRootViewController].view withText:@"Editing Product"];
        [CreateProductAPIHandler createProductContainerObject:self withProductCreateObject:productCreateContainerObject];
        
        NSMutableString *categoriesString = [NSMutableString stringWithCapacity:0];
        
        for (int i = 0; i < [productCreateContainerObject.mainObject.categoriesArray count]; i++)
        {
            [categoriesString appendString:[productCreateContainerObject.mainObject.categoriesArray objectAtIndex:i]];
            if (i != [productCreateContainerObject.mainObject.categoriesArray count] - 1)
                [categoriesString appendString:@" > "];
        }
        
        
        NSLog(@"make seller");
        [SellersAPIHandler makeCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject] withSellerAddressDictionary:[NSMutableDictionary dictionaryWithObject:categoriesString forKey:@"seller_category"]];
        
        
        
        
    }
    [self resignResponders];
    
    
}

-(void)productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    NSString *flurryString = [NSString stringWithFormat:@"Product created"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[InstagramUserObject getStoredUserObject].userID, @"user", nil];
    [Flurry logEvent:flurryString withParameters:params];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController  *rootVC = delegate.appRootViewController;
    [rootVC productDidCreateWithNavigationController:self.navigationController];
}

-(void)editProductComplete
{
    [self.jkProgressView hideProgressView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark table view data source delegate methods

-(void)updateLayout
{
    float extendHeight = 36;
    
    self.sizeQuantityTableViewController.tableView.frame = CGRectMake(0, self.sizeQuantityTableViewController.tableView.frame.origin.y, self.sizeQuantityTableViewController.tableView.frame.size.width, extendHeight * self.sizeQuantityTableViewController.rowShowCount + 11);
    
    
    if (self.sizeQuantityTableViewController.rowShowCount > 0 && [[self.sizeQuantityTableViewController getRemainingAvailableSizesArray] count] == 0)
        self.addSizeButton.frame = CGRectMake(self.addSizeButton.frame.origin.x, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height, self.sizeQuantityTableViewController.tableView.frame.size.width, 0);
    
    else
        self.addSizeButton.frame = CGRectMake(self.addSizeButton.frame.origin.x, self.sizeQuantityTableViewController.tableView.frame.origin.y + self.sizeQuantityTableViewController.tableView.frame.size.height - 11, self.sizeQuantityTableViewController.tableView.frame.size.width, 44);
    
    
    self.pricesView.frame = CGRectMake(self.pricesView.frame.origin.x, self.addSizeButton.frame.origin.y + self.addSizeButton.frame.size.height + 4, self.pricesView.frame.size.width, self.pricesView.frame.size.height);
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.pricesView.frame.origin.y + self.pricesView.frame.size.height + 1);
    
    
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
        //        [self updateLayout];
        
        if (self.sizeQuantityTableViewController.rowShowCount > 0 && [[self.sizeQuantityTableViewController getRemainingAvailableSizesArray] count] == 0)
            self.addSizeButton.alpha = 0;
        else
            self.addSizeButton.alpha = 1;
        
        
        
        NSLog(@"self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary: %@", self.sizeQuantityTableViewController.cellSizeQuantityValueDictionary);
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text compare:@"Description"] == NSOrderedSame)
        textView.text = @"";
    
    self.descriptionTextView.textColor = [UIColor whiteColor];
    self.descriptionTextView.scrollEnabled = YES;
    
    NSLog(@"textViewDidBeginEditing!");
    
    if (textView == self.descriptionTextView)
        [self resizeWithTextView:textView];
    
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([textView.text compare:@""] == NSOrderedSame)
    {
        textView.text = @"Description";
        textView.textColor = [UIColor lightGrayColor];
    }
    
    
    self.descriptionTextView.scrollEnabled = NO;
    CGSize otherSize = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width, 10000)];
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, otherSize.height + 9);
    textView.contentSize = CGSizeMake(textView.contentSize.width, otherSize.height+ 9);

    
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}



-(void)resizeWithTextView:(UITextView *)textView
{
    CGSize otherSize = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width, 10000)];
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:textView.font forKey: NSFontAttributeName];
    otherSize = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width * .95, 10000)
                                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:stringAttributes context:nil].size;
    
    
    float verticaloffset = 6;
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, otherSize.height + 9);
    textView.contentSize = CGSizeMake(textView.contentSize.width, otherSize.height+ 9);
    
    
    
    self.descriptionContainerView.frame = CGRectMake(self.descriptionContainerView.frame.origin.x, self.descriptionContainerView.frame.origin.y, self.descriptionContainerView.frame.size.width, textView.frame.size.height + 13);
    
    self.descriptionContainerView.backgroundImageView.frame = CGRectMake(0, 0, self.descriptionContainerView.frame.size.width, self.descriptionContainerView.frame.size.height);
    
    self.urlContainerView.frame = CGRectMake(self.urlContainerView.frame.origin.x, self.descriptionContainerView.frame.origin.y + self.descriptionContainerView.frame.size.height, self.urlContainerView.frame.size.width, self.urlContainerView.frame.size.height);
    
    self.urlButton.frame = CGRectMake(self.urlButton.frame.origin.x, self.urlContainerView.frame.origin.y, self.urlButton.frame.size.width, self.urlButton.frame.size.height);
    
    self.socialButtonContainerView.frame = CGRectMake(self.socialButtonContainerView.frame.origin.x, self.urlContainerView.frame.origin.y + self.urlContainerView.frame.size.height + 40, self.socialButtonContainerView.frame.size.width, self.socialButtonContainerView.frame.size.height);
    
    self.categoriesContainerView.frame = CGRectMake(self.categoriesContainerView.frame.origin.x, self.socialButtonContainerView.frame.origin.y + self.socialButtonContainerView.frame.size.height + verticaloffset, self.categoriesContainerView.frame.size.width, self.categoriesContainerView.frame.size.height);
    
    self.nextButton.frame = CGRectMake(self.nextButton.frame.origin.x, self.categoriesContainerView.frame.origin.y + self.categoriesContainerView.frame.size.height + verticaloffset, self.nextButton.frame.size.width, self.nextButton.frame.size.height);
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 1);

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"shouldChangeTextInRange!!!");
    if (textView == self.descriptionTextView)
    {
        if ([text compare:@"\n"] == NSOrderedSame)
            [textView resignFirstResponder];
        [self resizeWithTextView:textView];
    }
    
    return YES;
}


- (IBAction) urlButtonHit
{
    
    self.browserViewController = [[CIALBrowserViewController alloc] init];
    self.browserViewController.preloadedContent = @"<HTML>HI</HTML>";
    [self.navigationController pushViewController:self.browserViewController animated:YES];
    
    self.browserViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(browserSaveHit) ];
    //    [self.browserViewController loadRightBarItem];
    
    [self.descriptionTextView resignFirstResponder];
    
    //    NSLog(@"browserViewController.webView: %@", self.browserViewController.webView);
    
    
}

-(void)browserSaveHit
{
    NSLog(@"self.browserViewController.locationField.url: %@", self.browserViewController.url);
    
    self.urlLabel.text = [self.browserViewController.url absoluteString];
    [self linkSelectedWithURLString:[self.browserViewController.url absoluteString]];
    
    if (!self.isEdit)
        [self setDoneButtonState];
    
}
-(void) linkSelectedWithURLString:(NSString *)theURLString
{
    NSLog(@"theURLString: %@", theURLString);
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditingtextFieldDidBeginEditing textFieldDidBeginEditing");
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"textField: %@", textField);
    NSLog(@"string: %@", string);
    NSLog(@"string.length: %d", [string length]);
    
    
    BOOL returnValue = YES;
    if (textField == self.retailPriceTextField || textField == self.instashopPriceTextField)
    {
        if ([string compare:@"."] == NSOrderedSame)
            return NO;
        
        
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([textField.text length] > 1)
        {
            NSString *decimalValue = [textField.text substringWithRange:NSMakeRange([textField.text length] - 1, 1)];
            NSString *wholeValue = [textField.text substringWithRange:NSMakeRange(0, [textField.text length] - 1)];
            
            textField.text = [NSString stringWithFormat:@"%@.%@", wholeValue, decimalValue];
            
            
        }
        textField.text = [NSString stringWithFormat:@"$%@%@", textField.text, string];
        
        if ([string length] > 0)
            returnValue = NO;
        
    }
    
    
    return returnValue;
    
}


- (IBAction) facebookButtonHit
{
    NSLog(@"facebookButtonHit");
    self.facebookButton.selected = !self.facebookButton.selected;
    [SocialManager requestInitialFacebookAccess];
}

- (IBAction) twitterButtonHit
{
    NSLog(@"twitterButtonHit");
    self.twitterButton.selected = !self.twitterButton.selected;
    
    if (self.twitterButton.selected)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_TWITTER_ACCOUNT_ID_KEY] == nil)
            [SocialManager getAllTwitterAccountsWithResponseDelegate:self];
        else
            NSLog(@"[[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_TWITTER_ACCOUNT_ID_KEY]: %@", [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_TWITTER_ACCOUNT_ID_KEY]);
        
    }
    
}

-(void)twitterAccountsLookupDidCompleteWithArray:(NSArray *)theAccountsArray
{
    
    if ([theAccountsArray count] > 0)
    {
        UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.twitterAccountsArray = [[NSArray alloc] initWithArray:theAccountsArray];
        
        NSLog(@"self.twitterAccountsArray: %@", self.twitterAccountsArray);
        for (int i = 0; i < [self.twitterAccountsArray count]; i++)
        {
            ACAccount *theAccount = [self.twitterAccountsArray objectAtIndex:i];
            [shareActionSheet addButtonWithTitle:theAccount.username];
            NSLog(@"theAccount.username[%d]: %@", i, theAccount.username);
        }
        [shareActionSheet addButtonWithTitle:@"Cancel"];
        
        shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [shareActionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please add a twitter account in settings if you wish to post"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        self.twitterButton.selected = NO;
        
    }
    
}

- (void) actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [theActionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(@"buttonTitle: %@", buttonTitle);
    
    
    if ([buttonTitle compare:@"Cancel"] != NSOrderedSame)
        for (int i = 0; i < [self.twitterAccountsArray count]; i++)
        {
            ACAccount *theAccount = [self.twitterAccountsArray objectAtIndex:i];
            if ([theAccount.username compare:buttonTitle] == NSOrderedSame)
            {
                [[NSUserDefaults standardUserDefaults] setObject:theAccount.username forKey:SELECTED_TWITTER_ACCOUNT_ID_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
}


-(void)resignResponders
{
    [self.descriptionTextView resignFirstResponder];
    [self.retailPriceTextField resignFirstResponder];
    [self.instashopPriceTextField resignFirstResponder];
}





@end
