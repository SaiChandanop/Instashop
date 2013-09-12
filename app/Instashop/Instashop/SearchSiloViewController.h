//
//  SearchSiloViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectSelectTableViewController.h"


@class SearchViewController;
@class SearchButtonContainerView;

@interface SearchSiloViewController : UIViewController
{
    SearchViewController *parentController;
    
    UISearchBar *theSearchBar;
    UIImageView *searchTermsImageView;
    UILabel *searchPromptLabel;
    UIImageView *separatorImageView;
    
    UIView *contentContainerView;
    UINavigationController *categoriesNavigationController;
    ObjectSelectTableViewController *objectSelectTableViewController;
    
    NSMutableArray *selectedCategoriesArray;
    NSMutableArray *freeSearchTextArray;

    NSMutableArray *searchButtonsArray;
    int searchType;
}

-(void)searchButtonContainerHit:(SearchButtonContainerView *)theButton;

@property (nonatomic, retain) SearchViewController *parentController;

@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet UIImageView *searchTermsImageView;
@property (nonatomic, retain) IBOutlet UILabel *searchPromptLabel;
@property (nonatomic, retain) IBOutlet UIImageView *separatorImageView;

@property (nonatomic, retain) UIView *contentContainerView;
@property (nonatomic, retain) UINavigationController *categoriesNavigationController;
@property (nonatomic, retain) ObjectSelectTableViewController *objectSelectTableViewController;

@property (nonatomic, retain) NSMutableArray *selectedCategoriesArray;
@property (nonatomic, retain) NSMutableArray *freeSearchTextArray;

@property (nonatomic, retain) NSMutableArray *searchButtonsArray;

@property (nonatomic, assign) int searchType;

@end
