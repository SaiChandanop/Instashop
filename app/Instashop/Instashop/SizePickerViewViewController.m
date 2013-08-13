//
//  SizePickerViewViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SizePickerViewViewController.h"

@interface SizePickerViewViewController ()

@end

@implementation SizePickerViewViewController

@synthesize itemsArray, cellDelegate,thePickerView;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize type;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.itemsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow[%d]: %@", row, [self.itemsArray objectAtIndex:row]);
    
    if ([[self.itemsArray objectAtIndex:row] compare:@"(null)"] == NSOrderedSame)
        return @"";
    else
        return [self.itemsArray objectAtIndex:row];
    
}



@end
