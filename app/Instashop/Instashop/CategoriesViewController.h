//
//  CategoriesNavigationViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesTableViewController.h"

#define CATEGORIES_TYPE_PRODUCT 0
#define CATEGORIES_TYPE_SELLER 1

@interface CategoriesViewController : UIViewController
{
    id parentController;
    int categoriesType;
    NSArray *potentialCategoriesArray;
    NSMutableArray *selectedCategoriesArray;
    
    UITableView *initialTableReference;
    
    CategoriesTableViewController *initialCategoriesTableViewController;
    CategoriesTableViewController *categoriesTableViewController;
    
    NSMutableArray *subtableContainerViewsArray;
}

-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController;

@property (nonatomic, strong) id parentController;
@property (nonatomic, assign) int categoriesType;
@property (nonatomic, strong) NSArray *potentialCategoriesArray;
@property (nonatomic, strong) NSMutableArray *selectedCategoriesArray;

@property (nonatomic, strong) UITableView *initialTableReference;

@property (nonatomic, strong) CategoriesTableViewController *initialCategoriesTableViewController;
@property (nonatomic, strong) CategoriesTableViewController *categoriesTableViewController;

@property (nonatomic, strong) NSMutableArray *subtableContainerViewsArray;
@end
