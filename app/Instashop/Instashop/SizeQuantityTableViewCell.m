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
@synthesize sizeLabel;
@synthesize quantityLabel;
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


-(void) loadWithIndexPath:(NSIndexPath *)indexPath withContentDictionary:(NSDictionary *)contentDictionary
{
    self.backgroundColor = [UIColor blackColor];
    
    self.rowNumberLabel = (UILabel *)[self viewWithTag:0];
    self.sizeButton = (UIButton *)[self viewWithTag:1];
    self.quantityButton = (UIButton *)[self viewWithTag:2];
    
    self.sizeLabel = (UILabel *)[self viewWithTag:5];
    self.quantityLabel = (UILabel *)[self viewWithTag:6];
    
    [self addSubview:self.sizeLabel];
    [self addSubview:self.sizeButton];
    [self addSubview:self.quantityLabel];
    [self addSubview:self.quantityButton];
    
    
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    self.sizeLabel.text = @"Size";
    self.quantityLabel.text = @"Quantity";
    
    self.rowNumberLabel.font = [UIFont systemFontOfSize:16];
    self.rowNumberLabel.textColor = [UIColor whiteColor];
    self.sizeLabel.font = self.rowNumberLabel.font;
    self.sizeLabel.textColor = self.rowNumberLabel.textColor;
    self.quantityLabel.font = self.sizeLabel.font;
    self.quantityLabel.textColor = self.sizeLabel.textColor;

    
    [self.sizeButton addTarget:self action:@selector(sizeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.quantityButton  addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
    

    

    NSLog(@"sizeLabel: %@", sizeLabel);
    NSLog(@"self.sizeButton: %@", self.sizeButton);
    NSLog(@"self.quantityButton: %@", self.quantityButton);
    
    
        NSLog(@"self.subviews: %@", [self subviews]);
    
    
    
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
