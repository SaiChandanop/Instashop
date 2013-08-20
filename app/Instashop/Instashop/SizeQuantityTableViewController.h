//
//  SizeQuantityTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SIZE_DICTIONARY_KEY @"size dictionary key"
#define QUANTITY_DICTIONARY_KEY @"quantity dictionary Key"

@class ProductDetailsViewController;

@interface SizeQuantityTableViewController : UITableViewController
{
    ProductDetailsViewController *productDetailsViewController;
    
    NSMutableDictionary *cellSizeQuantityValueDictionary;
    NSArray *availableSizesArray;
    
    int rowShowCount;
    BOOL isButtonsDisabled;
}

-(NSArray *)getRemainingAvailableSizesArray;
-(void)xButtonHitWithIndexPath:(NSIndexPath *)theIndexPath;
-(void)ownerAddRowButtonHitWithTableView:(UITableView *)theTableView;
-(void)rowValueSelectedWithIndexPath:(NSIndexPath *)theIndexPath withKey:(NSString *)key withValue:(NSString *)value;

@property (nonatomic, retain) ProductDetailsViewController *productDetailsViewController;
@property (nonatomic, retain) NSMutableDictionary *cellSizeQuantityValueDictionary;
@property (nonatomic, retain) NSArray *availableSizesArray;

@property (nonatomic, assign) int rowShowCount;
@property (nonatomic, assign) BOOL isButtonsDisabled;

@end
