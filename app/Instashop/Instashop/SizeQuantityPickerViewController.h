//
//  SizeQuantityPickerViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeQuantityTableViewCell.h"
@interface SizeQuantityPickerViewController : UIViewController
{
    
    SizeQuantityTableViewCell *cellDelegate;
    NSArray *itemsArray;
    UIPickerView *thePickerView;
    
    
    UIButton *cancelButton;
    UIButton *saveButton;
    
    int selectedRow;
    
    NSString *typeKeyString;

}

@property (nonatomic, retain) SizeQuantityTableViewCell *cellDelegate;
@property (nonatomic, retain) NSArray *itemsArray;
@property (nonatomic, retain) IBOutlet UIPickerView *thePickerView;

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property (nonatomic, assign) int selectedRow;

@property (nonatomic, retain) NSString *typeKeyString;

@end


