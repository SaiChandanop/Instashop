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
@synthesize pickerSelectedIndex;
@synthesize pickerItemsArray;
@synthesize theIndexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.rowNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, self.frame.size.height)];
        self.rowNumberLabel.backgroundColor = [UIColor clearColor];
        self.rowNumberLabel.textAlignment = NSTextAlignmentCenter;
        self.rowNumberLabel.textColor = [UIColor whiteColor];
        self.rowNumberLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.rowNumberLabel];
        
        float buttonWidth = 80;
        float buttonHeight = 30;
        
        self.sizeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        self.sizeButton.frame = CGRectMake(self.frame.size.width / 4 - buttonWidth / 2, self.frame.size.height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
        [self addSubview:self.sizeButton];
        
        self.quantityButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        self.quantityButton.frame = CGRectMake(self.frame.size.width / 2 + self.frame.size.width / 4 - buttonWidth / 2, self.frame.size.height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
        [self.quantityButton addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.quantityButton];
        
        
        self.pickerItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 100; i++)
            [self.pickerItemsArray addObject:[NSString stringWithFormat:@"%d", i]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle
{
    self.theIndexPath = indexPath;
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    [self.sizeButton setTitle:@"size" forState:UIControlStateNormal];
    [self.quantityButton setTitle:@"quant" forState:UIControlStateNormal];
    
 
    if (sizeTitle == nil)
        [self.sizeButton setTitle:@"NIL" forState:UIControlStateNormal];
    else
        [self.sizeButton setTitle:sizeTitle forState:UIControlStateNormal];
    
    [self.quantityButton setTitle:@"0" forState:UIControlStateNormal];
    
}


-(void)quantityButtonHit
{
    
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


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pickerSelectedIndex = row;

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
    [self.parentController cellSelectedValue:[self.pickerItemsArray objectAtIndex:self.pickerSelectedIndex] withIndexPath:self.theIndexPath];    
    [self.quantityButton setTitle:[NSString stringWithFormat:@"%d", self.pickerSelectedIndex] forState:UIControlStateNormal];
    [self dismissPicker];
}


@end
