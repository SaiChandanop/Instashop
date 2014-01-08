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


@property (nonatomic, strong) SizeQuantityTableViewController *parentController;

@property (nonatomic, strong) SizePickerViewViewController *theController;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) NSIndexPath *theIndexPath;

@property (nonatomic, strong) IBOutlet UILabel *rowNumberLabel;
@property (nonatomic, strong) IBOutlet UIButton *sizeButton;
@property (nonatomic, strong) IBOutlet UIButton *quantityButton;
@property (nonatomic, strong) IBOutlet UIButton *xButton;

@property (nonatomic, strong) NSArray *avaliableSizesArray;
@property (nonatomic, strong) NSString *selectedSizeValue;
@property (nonatomic, strong) NSString *selectedQuantityValue;


@end
