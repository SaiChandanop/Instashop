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
    NSString *directSearchTerm;
    
}

- (IBAction) shopsButtonHit:(UIButton *)theButton;
- (IBAction) productsButtonHit:(UIButton *)theButton;
-(void) rowSelectionOccured:(NSDictionary *)theSelectionObject;

@property (nonatomic, strong) AppRootViewController *appRootViewController;

@property (nonatomic, strong) SearchSiloViewController *productSearchViewController;
@property (nonatomic, strong) SearchSiloViewController *shopSearchViewController;

@property (nonatomic, strong) IBOutlet UIButton *shopsButton;
@property (nonatomic, strong) IBOutlet UIButton *productsButton;
@property (nonatomic, strong) IBOutlet UIView *nibHighlightView;
@property (nonatomic, strong) UIView *theHighlightView;
@property (nonatomic, strong) NSString *directSearchTerm;




@end
