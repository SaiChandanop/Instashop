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
}

-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController;

@property (nonatomic, retain) id parentController;
@property (nonatomic, assign) int categoriesType;
@property (nonatomic, retain) NSArray *potentialCategoriesArray;
@property (nonatomic, retain) NSMutableArray *selectedCategoriesArray;

@property (nonatomic, retain) UITableView *initialTableReference;
@end
