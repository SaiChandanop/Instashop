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

#define PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS 1
#define PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER 2


@class ProductCreateViewController;

@interface ProductSelectTableViewController : UITableViewController <IGRequestDelegate, CellSelectionOccuredProtocol, FeedRequestFinishedProtocol>
{
    id parentController;
    id cellDelegate;
    
    NSMutableArray *contentArray;
    NSMutableDictionary *contentRequestParameters;

    UITableView *referenceTableView;
    
    
    int productRequestorType;
    NSString *productRequestorReferenceObject;
}

-(void)refreshContent;

@property (nonatomic, retain) id parentController;
@property (nonatomic, retain) id cellDelegate;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, retain) NSMutableDictionary *contentRequestParameters;

@property (nonatomic, retain) UITableView *referenceTableView;

@property (nonatomic, assign) int productRequestorType;
@property (nonatomic, retain) NSString *productRequestorReferenceObject;
@end
