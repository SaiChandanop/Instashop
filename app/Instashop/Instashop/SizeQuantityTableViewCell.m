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
@synthesize sizeButton;
@synthesize quantityButton;
@synthesize actionSheet;
@synthesize avaliableSizesArray;
@synthesize selectedSizeValue;
@synthesize selectedQuantityValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


-(void) loadWithIndexPath:(NSIndexPath *)indexPath withContentDictionary:(NSDictionary *)contentDictionary
{
    self.theIndexPath = indexPath;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.rowNumberLabel = (UILabel *)[self viewWithTag:0];
    self.sizeButton = (UIButton *)[self viewWithTag:1];
    self.quantityButton = (UIButton *)[self viewWithTag:2];

    
    [self addSubview:self.sizeButton];
    [self addSubview:self.quantityButton];
    
    
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];

    
    NSDictionary *thisCellsContent = [contentDictionary objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    if (thisCellsContent != nil)
    {
        if ([thisCellsContent objectForKey:SIZE_DICTIONARY_KEY] != nil)
            [self.sizeButton setTitle:[thisCellsContent objectForKey:SIZE_DICTIONARY_KEY] forState:UIControlStateNormal];
        
        if ([thisCellsContent objectForKey:QUANTITY_DICTIONARY_KEY] != nil)
            [self.quantityButton setTitle:[thisCellsContent objectForKey:QUANTITY_DICTIONARY_KEY] forState:UIControlStateNormal];
    }
    
    
    self.rowNumberLabel.font = [UIFont systemFontOfSize:16];
    self.rowNumberLabel.textColor = [UIColor whiteColor];
        
    [self.sizeButton addTarget:self action:@selector(sizeButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.quantityButton  addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
}


-(IBAction)sizeButtonHit
{
    NSLog(@"sizeButtonHit");
    if ([self.avaliableSizesArray count] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"No need for a size here"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    else
    {
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.theController = [[SizeQuantityPickerViewController alloc] initWithNibName:@"SizeQuantityPickerViewController" bundle:nil];
        self.theController.itemsArray = [[NSArray alloc] initWithArray:self.avaliableSizesArray];
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        self.actionSheet.autoresizesSubviews = NO;
        self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [self.actionSheet addSubview:self.theController.view];
        
        [self.actionSheet showFromRect:CGRectMake(0,del.appRootViewController.view.frame.size.height, del.appRootViewController.view.frame.size.width,del.appRootViewController.view.frame.size.width) inView:del.appRootViewController.view animated:YES];
        [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
        
        
        [self.theController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.theController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
        
        self.theController.typeKeyString = SIZE_DICTIONARY_KEY;
    }
}


-(void)quantityButtonHit
{
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 100; i++)
        [ar addObject:[NSString stringWithFormat:@"%d", i + 1]];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.theController = [[SizeQuantityPickerViewController alloc] initWithNibName:@"SizeQuantityPickerViewController" bundle:nil];
    self.theController.itemsArray = [[NSArray alloc] initWithArray:ar];
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self     cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet.autoresizesSubviews = NO;
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.actionSheet addSubview:self.theController.view];
    
    [self.actionSheet showFromRect:CGRectMake(0,del.appRootViewController.view.frame.size.height, del.appRootViewController.view.frame.size.width,del.appRootViewController.view.frame.size.width) inView:del.appRootViewController.view animated:YES];
    [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
    
    
    [self.theController.cancelButton addTarget:self action:@selector(pickerCancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.theController.saveButton addTarget:self action:@selector(pickerSaveButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
    self.theController.typeKeyString = QUANTITY_DICTIONARY_KEY;
}



-(void)dismissPicker
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)pickerCancelButtonHit
{
    [self dismissPicker];
    
}

-(void)pickerSaveButtonHit
{
    NSLog(@"pickerSaveButtonHit");
    [self.parentController rowValueSelectedWithIndexPath:self.theIndexPath withKey:self.theController.typeKeyString withValue:[self.theController.itemsArray objectAtIndex:self.theController.selectedRow]];
    [self dismissPicker];
}


@end
