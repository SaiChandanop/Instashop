//
//  CategoriesTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoriesNavigationViewController;

@interface CategoriesTableViewController : UITableViewController
{
    CategoriesNavigationViewController *parentController;
    
    NSArray *categoriesArray;
    int positionIndex;
}

@property (nonatomic, retain) CategoriesNavigationViewController *parentController;
@property (nonatomic, retain) NSArray *categoriesArray;
@property (nonatomic, assign) int positionIndex;

@end
