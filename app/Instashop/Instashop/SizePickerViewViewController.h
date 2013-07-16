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
}

@property (nonatomic, retain) SizeQuantityTableViewCell *cellDelegate;
@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, retain) IBOutlet UIPickerView *thePickerView;

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@end
