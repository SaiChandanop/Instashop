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
#import "SizeQuantityPickerViewController.h"

@implementation SizeQuantityTableViewCell



@synthesize parentController;

@synthesize theIndexPath;

@synthesize theController;
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
    NSLog(@"loadWithIndexPath contentDictionary: %@", contentDictionary);
    self.theIndexPath = indexPath;
    
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
    
    NSDictionary *thisCellsContent = [contentDictionary objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    if (thisCellsContent != nil)
    {
        if ([thisCellsContent objectForKey:SIZE_DICTIONARY_KEY] != nil)
            self.sizeLabel.text = [thisCellsContent objectForKey:SIZE_DICTIONARY_KEY];
        
        if ([thisCellsContent objectForKey:QUANTITY_DICTIONARY_KEY] != nil)
            self.quantityLabel.text = [thisCellsContent objectForKey:QUANTITY_DICTIONARY_KEY];
    }
    
    
    self.rowNumberLabel.font = [UIFont systemFontOfSize:16];
    self.rowNumberLabel.textColor = [UIColor whiteColor];
    self.sizeLabel.font = self.rowNumberLabel.font;
    self.sizeLabel.textColor = self.rowNumberLabel.textColor;
    self.quantityLabel.font = self.sizeLabel.font;
    self.quantityLabel.textColor = self.sizeLabel.textColor;

    
    [self.sizeButton addTarget:self action:@selector(sizeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.quantityButton  addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
}


-(IBAction)sizeButtonHit
{
    self.theController = [[SizeQuantityPickerViewController alloc] initWithNibName:@"SizeQuantityPickerViewController" bundle:nil];
    self.theController.itemsArray = [[NSArray alloc] initWithArray:self.avaliableSizesArray];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.appRootViewController presentViewController:theController animated:YES completion:nil];
    
    [self.theController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.theController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];

    self.theController.typeKeyString = SIZE_DICTIONARY_KEY;
}



-(void)quantityButtonHit
{
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 100; i++)
        [ar addObject:[NSString stringWithFormat:@"%d", i + 1]];
    
    self.theController = [[SizeQuantityPickerViewController alloc] initWithNibName:@"SizeQuantityPickerViewController" bundle:nil];
    self.theController.itemsArray = [[NSArray alloc] initWithArray:ar];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.appRootViewController presentViewController:theController animated:YES completion:nil];
    
    [self.theController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.theController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
    self.theController.typeKeyString = QUANTITY_DICTIONARY_KEY;
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
    [self.parentController rowValueSelectedWithIndexPath:self.theIndexPath withKey:self.theController.typeKeyString withValue:[self.theController.itemsArray objectAtIndex:self.theController.selectedRow]];
    [self dismissPicker];
}


@end
