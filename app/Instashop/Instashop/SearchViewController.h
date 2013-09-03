//
//  SearchViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchReturnedReceiverProtocol.h"

#define SEARCH_RESULT_TYPE_PRODUCT 0
#define SEARCH_RESULT_TYPE_SELLER 1

@class AppRootViewController;
@interface SearchViewController : UIViewController <UISearchBarDelegate, SearchReturnedReceiverProtocol, UITableViewDataSource, UITableViewDelegate>
{
    AppRootViewController *appRootViewController;
    
    UISearchBar *theSearchBar;
    UITableView *searchResultsTableView;
    
    NSMutableArray *searchResultsArray;
    
}
@property (nonatomic, retain) AppRootViewController *appRootViewController;

@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet UITableView *searchResultsTableView;

@property (nonatomic, retain) NSMutableArray *searchResultsArray;

@end
