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
#import "SearchSiloViewController.h"


#define SEARCH_RESULT_TYPE_PRODUCT 0
#define SEARCH_RESULT_TYPE_SELLER 1

@class AppRootViewController;
@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CellSelectionOccuredProtocol>
{
    AppRootViewController *appRootViewController;
    
    SearchSiloViewController *productSearchViewController;
    SearchSiloViewController *shopSearchViewController;
    
    UIButton *shopsButton;
    UIButton *productsButton;
    UIView *nibHighlightView;
    UIView *theHighlightView;
    
    
}

- (IBAction) shopsButtonHit:(UIButton *)theButton;
- (IBAction) productsButtonHit:(UIButton *)theButton;

@property (nonatomic, retain) AppRootViewController *appRootViewController;

@property (nonatomic, retain) SearchSiloViewController *productSearchViewController;
@property (nonatomic, retain) SearchSiloViewController *shopSearchViewController;

@property (nonatomic, retain) IBOutlet UIButton *shopsButton;
@property (nonatomic, retain) IBOutlet UIButton *productsButton;
@property (nonatomic, retain) IBOutlet UIView *nibHighlightView;
@property (nonatomic, retain) UIView *theHighlightView;




@end
