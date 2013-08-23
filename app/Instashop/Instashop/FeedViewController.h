//
//  FeedViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellSelectionOccuredProtocol.h"
#import "FeedRequestFinishedProtocol.h"
#import "ProductSelectTableViewController.h"
@class AppRootViewController;

@interface FeedViewController : UIViewController <CellSelectionOccuredProtocol>
{
    AppRootViewController *parentController;
    
    NSMutableArray *feedItemsArray;
    
    id selectedObject;
    
    ProductSelectTableViewController *productSelectTableViewController;
    UITableView *theTableView;
}

@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) NSMutableArray *feedItemsArray;

@property (nonatomic, retain) id selectedObject;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@end
