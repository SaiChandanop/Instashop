//
//  CategoriesPickerViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailsViewController;
@interface CategoriesPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    ProductDetailsViewController *delegate;
    
    int type;
    NSArray *itemsArray;
    
    int selectedIndex;
}

- (IBAction)cancelButtonHit;
- (IBAction)doneButtonHit;

@property (nonatomic, retain) ProductDetailsViewController *delegate;

@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSArray *itemsArray;

@property (nonatomic, assign) int selectedIndex;
@end
