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

@interface SizeQuantityTableViewController : UITableViewController
{
    NSMutableDictionary *cellSizeQuantityValueDictionary;
    NSArray *availableSizesArray;
    
    
    int rowShowCount;
}

-(void)cellSelectedValue:(NSString *)value withIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSMutableDictionary *cellSizeQuantityValueDictionary;
@property (nonatomic, retain) NSArray *availableSizesArray;


@property (nonatomic, assign) int rowShowCount;

@end
