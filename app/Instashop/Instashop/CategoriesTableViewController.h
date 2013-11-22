//
//  CategoriesTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoriesViewController;

@interface CategoriesTableViewController : UITableViewController
{
    CategoriesViewController *parentController;
    int categoriesType;
    NSArray *categoriesArray;
    NSArray *basePriorCategoriesArray;
    int positionIndex;
    
    NSString *titleString;
}

@property (nonatomic, retain) CategoriesViewController *parentController;
@property (nonatomic, assign) int categoriesType;
@property (nonatomic, retain) NSArray *categoriesArray;
@property (nonatomic, retain) NSArray *basePriorCategoriesArray;
@property (nonatomic, assign) int positionIndex;
@property (nonatomic, retain) NSString *titleString;
@end
