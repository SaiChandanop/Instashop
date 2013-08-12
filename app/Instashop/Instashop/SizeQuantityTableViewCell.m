//
//  SizeQuantityTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SizeQuantityTableViewCell.h"
#import "AppDelegate.h"
#import "AppRootViewController.h"
#import "SizePickerViewViewController.h"

@implementation SizeQuantityTableViewCell



@synthesize parentController;

@synthesize rowNumberLabel;
@synthesize sizeButton;
@synthesize quantityButton;

@synthesize avaliableSizesArray;
@synthesize selectedSizeValue;
@synthesize selectedQuantityValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /*
        self.pickerItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 100; i++)
            [self.pickerItemsArray addObject:[NSString stringWithFormat:@"%d", i]];
         */

    }
    return self;
}


-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle
{
    self.rowNumberLabel = (UILabel *)[self viewWithTag:0];
    self.sizeButton = (UIButton *)[self viewWithTag:1];
    self.quantityButton = (UIButton *)[self viewWithTag:2];
    
    [self.sizeButton addTarget:self action:@selector(sizeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.quantityButton  addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sizeButton setTitle:@"Size!" forState:UIControlStateNormal];
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
/*    self.theIndexPath = indexPath;
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    [self.sizeButton setTitle:@"size" forState:UIControlStateNormal];
    [self.quantityButton setTitle:@"quant" forState:UIControlStateNormal];
    
 
    if (sizeTitle == nil)
        [self.sizeButton setTitle:@"NIL" forState:UIControlStateNormal];
    else
        [self.sizeButton setTitle:sizeTitle forState:UIControlStateNormal];
    
    [self.quantityButton setTitle:@"0" forState:UIControlStateNormal];
  */
}


-(IBAction)sizeButtonHit
{
    NSLog(@"sizeButtonHit");
    
}



-(void)quantityButtonHit
{
    NSLog(@"quantityButtonHit");
    
    SizePickerViewViewController *sizePickerViewViewController = [[SizePickerViewViewController alloc] initWithNibName:@"SizePickerViewViewController" bundle:nil];
    sizePickerViewViewController.thePickerView.delegate = self;
    sizePickerViewViewController.thePickerView.dataSource = self;
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.appRootViewController presentViewController:sizePickerViewViewController animated:YES completion:nil];

    sizePickerViewViewController.thePickerView.delegate = self;
    sizePickerViewViewController.thePickerView.dataSource = self;

    [sizePickerViewViewController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [sizePickerViewViewController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
}


/*
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerItemsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{    
    return [self.pickerItemsArray objectAtIndex:row];
    
}
*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    self.pickerSelectedIndex = row;

    NSLog(@"picker view did select row: %d", row);
}

-(void)dismissPicker
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.appRootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)pickerCancelButtonHit
{
    [self dismissPicker];

}

-(void)pickerSaveButtonHit
{
//    [self.parentController cellSelectedValue:[self.pickerItemsArray objectAtIndex:self.pickerSelectedIndex] withIndexPath:self.theIndexPath];
  //  [self.quantityButton setTitle:[NSString stringWithFormat:@"%d", self.pickerSelectedIndex] forState:UIControlStateNormal];
    [self dismissPicker];
}


@end
