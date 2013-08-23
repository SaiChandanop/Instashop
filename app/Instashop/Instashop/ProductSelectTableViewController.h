//
//  ProductSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellSelectionOccuredProtocol.h"
#import "Instagram.h"
#import "FeedRequestFinishedProtocol.h"
@class ProductCreateViewController;

@interface ProductSelectTableViewController : UITableViewController <IGRequestDelegate, CellSelectionOccuredProtocol, FeedRequestFinishedProtocol>
{
    id parentController;
    
    NSMutableArray *contentArray;
    NSMutableDictionary *contentRequestParameters;

    UITableView *referenceTableView;
}

-(void)refreshContent;

@property (nonatomic, retain) id parentController;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSMutableDictionary *contentRequestParameters;

@property (nonatomic, retain) UITableView *referenceTableView;
@end
