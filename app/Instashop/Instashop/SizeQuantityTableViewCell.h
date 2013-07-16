//
//  SizeQuantityTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeQuantityTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UILabel *rowNumberLabel;
    UIButton *sizeButton;
    UIButton *quantityButton;
    
    int pickerSelectedIndex;
    NSMutableArray *pickerItemsArray;
    
}

-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle;

@property (nonatomic, retain) UILabel *rowNumberLabel;
@property (nonatomic, retain) UIButton *sizeButton;
@property (nonatomic, retain) UIButton *quantityButton;


@property (nonatomic, assign) int pickerSelectedIndex;
@property (nonatomic, retain) NSMutableArray *pickerItemsArray;


@end
