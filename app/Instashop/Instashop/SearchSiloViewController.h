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
-(void)doDirectSearch:(NSString *)directSearchTerm;

@property (nonatomic, strong) SearchViewController *parentController;

@property (nonatomic, strong) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, strong) IBOutlet UIImageView *searchTermsImageView;
@property (nonatomic, strong) IBOutlet UILabel *searchPromptLabel;
@property (nonatomic, strong) IBOutlet UIImageView *separatorImageView;

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UINavigationController *categoriesNavigationController;
@property (nonatomic, strong) ObjectSelectTableViewController *objectSelectTableViewController;

@property (nonatomic, strong) NSMutableArray *selectedCategoriesArray;
@property (nonatomic, strong) NSMutableArray *freeSearchTextArray;

@property (nonatomic, strong) NSMutableArray *searchButtonsArray;

@property (nonatomic, assign) int searchType;

@end
