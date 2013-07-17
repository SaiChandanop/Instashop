//
//  SizeQuantityTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeQuantityTableViewController.h"
@interface SizeQuantityTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
{
    SizeQuantityTableViewController *parentController;
    UILabel *rowNumberLabel;
    UIButton *sizeButton;
    UIButton *quantityButton;
    
    int pickerSelectedIndex;
    NSMutableArray *pickerItemsArray;
    NSIndexPath *theIndexPath;
}

-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle;

@property (nonatomic, retain) SizeQuantityTableViewController *parentController;

@property (nonatomic, retain) UILabel *rowNumberLabel;
@property (nonatomic, retain) UIButton *sizeButton;
@property (nonatomic, retain) UIButton *quantityButton;


@property (nonatomic, assign) int pickerSelectedIndex;
@property (nonatomic, retain) NSMutableArray *pickerItemsArray;
@property (nonatomic, retain) NSIndexPath *theIndexPath;

@end
