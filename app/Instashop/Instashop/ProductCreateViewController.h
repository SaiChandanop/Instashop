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
#import "ProductCreateContainerProtocol.h"
#import "CellSelectionOccuredProtocol.h"

@class AppRootViewController;

@interface ProductCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, CellSelectionOccuredProtocol, ProductCreateContainerProtocol>
{
    AppRootViewController *parentController;
    
    ProductSelectTableViewController *productSelectTableViewController;

    NSDictionary *productDictionary;
    
    NSDictionary *currentSelectionObject;
}

-(void) forceRefreshContent;
-(void) previewDoneButtonHit:(ProductCreateContainerObject *)theCreateObject;
-(void) tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary;
-(void) previewButtonHitWithProductCreateObject:(ProductCreateContainerObject *)productCreateObject;
-(void) productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject;


@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;

@property (nonatomic, retain) NSDictionary *productDictionary;

@property (nonatomic, retain) NSDictionary *currentSelectionObject;
@end
