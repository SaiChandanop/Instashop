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

@property (nonatomic, strong) CategoriesViewController *parentController;
@property (nonatomic, assign) int categoriesType;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) NSArray *basePriorCategoriesArray;
@property (nonatomic, assign) int positionIndex;
@property (nonatomic, strong) NSString *titleString;
@end
