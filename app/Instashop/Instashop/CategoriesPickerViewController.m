//
//  CategoriesPickerViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesPickerViewController.h"
#import "ProductDetailsViewController.h"


@interface CategoriesPickerViewController ()

@end

@implementation CategoriesPickerViewController

@synthesize delegate;
@synthesize type;
@synthesize itemsArray;
@synthesize selectedIndex;
@synthesize thePickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [self.itemsArray objectAtIndex:row];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonHit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButtonHit
{
    NSLog(@"done: %@", [self.itemsArray objectAtIndex:self.selectedIndex]);
//    [self.delegate categorySelected:[self.itemsArray objectAtIndex:self.selectedIndex]];
    [self.delegate categorySelected:[self.itemsArray objectAtIndex:self.selectedIndex] withCategoriesPickerViewController:self];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

@end
