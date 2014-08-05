//
//  ObjectSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellSelectionOccuredProtocol.h"
#import "Instagram.h"
#import "FeedRequestFinishedProtocol.h"
#import "SearchRequestObject.h"
#import "SearchAPIHandler.h"
#import "SearchReturnedReceiverProtocol.h"

#define PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS 1
#define PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER 2
#define PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER 3
#define PRODUCT_REQUESTOR_TYPE_SEARCH 4


@interface ObjectSelectTableViewController : UITableViewController <IGRequestDelegate, CellSelectionOccuredProtocol, FeedRequestFinishedProtocol, SearchReturnedReceiverProtocol>
{
    id parentController;
    id cellDelegate;
    id rowSelectedDelegate;
    
    NSMutableArray *contentArray;
    NSMutableDictionary *contentRequestParameters;
    
    UITableView *referenceTableView;
    
    
    int productRequestorType;
    NSString *productRequestorReferenceObject;
    
    SearchRequestObject *searchRequestObject;
}

-(void)refreshContent;

@property (nonatomic, strong) id parentController;
@property (nonatomic, strong) id cellDelegate;
@property (nonatomic, strong) id rowSelectedDelegate;

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableDictionary *contentRequestParameters;

@property (nonatomic, strong) UITableView *referenceTableView;

@property (nonatomic, assign) int productRequestorType;
@property (nonatomic, strong) NSString *productRequestorReferenceObject;

@property (nonatomic, strong) SearchRequestObject *searchRequestObject;

@end
