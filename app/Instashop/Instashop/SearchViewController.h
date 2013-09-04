//
//  SearchViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchReturnedReceiverProtocol.h"
#import "CategoriesTableViewController.h"

#define SEARCH_RESULT_TYPE_PRODUCT 0
#define SEARCH_RESULT_TYPE_SELLER 1

@class AppRootViewController;
@interface SearchViewController : UIViewController <UISearchBarDelegate, SearchReturnedReceiverProtocol, UITableViewDataSource, UITableViewDelegate>
{
    AppRootViewController *appRootViewController;
    
    UISearchBar *theSearchBar;
    
    UIImageView *searchTermsImageView;
    UIButton *searchCategoriesButton;
    
    
    UIButton *shopsButton;
    UIButton *productsButton;
    UIButton *hashtagsButton;
    UIView *highlightView;
    
    UIView *containerReferenceView;
    
    UIView *productContainerView;
    UINavigationController *productCategoriesNavigationController;
    
    NSMutableArray *searchResultsArray;
    
    NSMutableArray *selectedCategoriesArray;
    
    NSMutableArray *freeSearchButtonsArray;
    
    
}

-(IBAction)shopsButtonHit:(UIButton *)theButton;
-(IBAction)productsButtonHit:(UIButton *)theButton;
-(IBAction)hashtagButtonHit:(UIButton *)theButton;

@property (nonatomic, retain) AppRootViewController *appRootViewController;

@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;

@property (nonatomic, retain) IBOutlet UIImageView *searchTermsImageView;
@property (nonatomic, retain) UIButton *searchCategoriesButton;

@property (nonatomic, retain) IBOutlet UIButton *shopsButton;
@property (nonatomic, retain) IBOutlet UIButton *productsButton;
@property (nonatomic, retain) IBOutlet UIButton *hashtagsButton;
@property (nonatomic, retain) IBOutlet UIView *highlightView;

@property (nonatomic, retain) IBOutlet UIView *containerReferenceView;

@property (nonatomic, retain) UIView *productContainerView;
@property (nonatomic, retain) UINavigationController *productCategoriesNavigationController;

@property (nonatomic, retain) NSMutableArray *searchResultsArray;


@property (nonatomic, retain) NSMutableArray *selectedCategoriesArray;

@property (nonatomic, retain) NSMutableArray *freeSearchButtonsArray;

@end
