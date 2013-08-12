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
    UILabel *sizeLabel;
    UILabel *quantityLabel;
    UIButton *sizeButton;
    UIButton *quantityButton;
    
    NSArray *avaliableSizesArray;
    NSString *selectedSizeValue;
    NSString *selectedQuantityValue;
}

-(void) loadWithIndexPath:(NSIndexPath *)indexPath withContentDictionary:(NSDictionary *)contentDictionary;


@property (nonatomic, retain) SizeQuantityTableViewController *parentController;

@property (nonatomic, retain) IBOutlet UILabel *rowNumberLabel;
@property (nonatomic, retain) UILabel *sizeLabel;
@property (nonatomic, retain) UILabel *quantityLabel;
@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UIButton *quantityButton;


@property (nonatomic, retain) NSArray *avaliableSizesArray;
@property (nonatomic, retain) NSString *selectedSizeValue;
@property (nonatomic, retain) NSString *selectedQuantityValue;



@end
