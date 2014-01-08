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

@property (nonatomic, strong) AppRootViewController *parentController;

@property (nonatomic, strong) NSMutableArray *feedItemsArray;

@property (nonatomic, strong) id selectedObject;

@property (nonatomic, strong) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@end
