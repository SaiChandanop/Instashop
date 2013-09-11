//
//  SearchSiloViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectTableViewController.h"


@interface SearchSiloViewController : UIViewController
{
    
    UISearchBar *theSearchBar;
    UIImageView *searchTermsImageView;
    UILabel *searchPromptLabel;
    UIImageView *separatorImageView;
    
    UIView *contentContainerView;
    UINavigationController *categoriesNavigationController;
    ProductSelectTableViewController *productSelectTableViewController;
    
    NSMutableArray *selectedCategoriesArray;
    NSMutableArray *freeSearchButtonsArray;

    
    int searchType;
}


@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet UIImageView *searchTermsImageView;
@property (nonatomic, retain) IBOutlet UILabel *searchPromptLabel;
@property (nonatomic, retain) IBOutlet UIImageView *separatorImageView;

@property (nonatomic, retain) UIView *contentContainerView;
@property (nonatomic, retain) UINavigationController *categoriesNavigationController;
@property (nonatomic, retain) ProductSelectTableViewController *productSelectTableViewController;

@property (nonatomic, retain) NSMutableArray *selectedCategoriesArray;
@property (nonatomic, retain) NSMutableArray *freeSearchButtonsArray;

@property (nonatomic, assign) int searchType;

@end
