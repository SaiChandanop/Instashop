//
//  SizePickerViewViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeQuantityTableViewCell.h"

@interface SizePickerViewViewController : UIViewController <UIPickerViewDelegate>
{
    
    SizeQuantityTableViewCell *cellDelegate;
    NSMutableArray *itemsArray;
    UIPickerView *thePickerView;
    
    UIButton *cancelButton;
    UIButton *saveButton;
    
    int type;
    NSString *typeKeyString;
    int selectedRow;
}

@property (nonatomic, strong) SizeQuantityTableViewCell *cellDelegate;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) IBOutlet UIPickerView *thePickerView;

@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *typeKeyString;
@property (nonatomic, assign) int selectedRow;

@end
