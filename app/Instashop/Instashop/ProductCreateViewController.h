//
//  ProductCreateViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectTableViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductCreateObject.h"
#import "ProductPreviewViewController.h"
#import "ProductCreateContainerObject.h"

@class AppRootViewController;

@interface ProductCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    AppRootViewController *parentController;
    
    ProductSelectTableViewController *productSelectTableViewController;
    ProductDetailsViewController *productDetailsViewController;

    NSDictionary *productDictionary;
}

-(void) previewDoneButtonHit:(ProductCreateContainerObject *)theCreateObject;

-(void)vcDidHitBackWithController:(UIViewController *)requestingViewController;
-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary;
-(void)previewButtonHitWithProductCreateObject:(ProductCreateContainerObject *)productCreateObject;
-(void)productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject;
- (void)createProductActionHitWithProductObject:(ProductCreateObject *)productCreateObject;
- (IBAction) exitButtonHit;
- (IBAction) goButtonHit;

@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet ProductDetailsViewController *productDetailsViewController;

@property (nonatomic, retain) NSDictionary *productDictionary;
@end
