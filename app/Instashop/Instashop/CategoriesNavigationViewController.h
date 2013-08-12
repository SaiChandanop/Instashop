//
//  CategoriesNavigationViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesTableViewController.h"

@class ProductDetailsViewController;

@interface CategoriesNavigationViewController : UIViewController
{
    ProductDetailsViewController *parentController;
    NSMutableArray *selectedCategoriesArray;
    
    UITableView *initialTableReference;
}

-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController;

@property (nonatomic, retain) ProductDetailsViewController *parentController;
@property (nonatomic, retain) NSMutableArray *selectedCategoriesArray;

@property (nonatomic, retain) UITableView *initialTableReference;
@end
