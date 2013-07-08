//
//  CategoriesPickerViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int type;
    NSArray *itemsArray;
    
    int selectedIndex;
}

- (IBAction)cancelButtonHit;
- (IBAction)doneButtonHit;

@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSArray *itemsArray;

@property (nonatomic, assign) int selectedIndex;
@end
