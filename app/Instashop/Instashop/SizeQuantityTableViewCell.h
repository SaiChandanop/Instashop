//
//  SizeQuantityTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeQuantityTableViewController.h"


#define PICKER_TYPE_SIZE 1
#define PICKER_TYPE_QUANTITY 2

@class SizePickerViewViewController;

@interface SizeQuantityTableViewCell : UITableViewCell <UIPickerViewDelegate, UIActionSheetDelegate>
{
    SizeQuantityTableViewController *parentController;
    
    SizePickerViewViewController *theController;
    UIActionSheet *actionSheet;
    
    NSIndexPath *theIndexPath;
    
    UILabel *rowNumberLabel;
    UIButton *sizeButton;
    UIButton *quantityButton;
    UIButton *xButton;
    
    NSArray *avaliableSizesArray;
    NSString *selectedSizeValue;
    NSString *selectedQuantityValue;
    
    
    
}

-(void) loadWithIndexPath:(NSIndexPath *)indexPath withContentDictionary:(NSDictionary *)contentDictionary;


@property (nonatomic, retain) SizeQuantityTableViewController *parentController;

@property (nonatomic, retain) SizePickerViewViewController *theController;
@property (nonatomic, retain) UIActionSheet *actionSheet;

@property (nonatomic, retain) NSIndexPath *theIndexPath;

@property (nonatomic, retain) IBOutlet UILabel *rowNumberLabel;
@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UIButton *quantityButton;
@property (nonatomic, retain) IBOutlet UIButton *xButton;

@property (nonatomic, retain) NSArray *avaliableSizesArray;
@property (nonatomic, retain) NSString *selectedSizeValue;
@property (nonatomic, retain) NSString *selectedQuantityValue;


@end
