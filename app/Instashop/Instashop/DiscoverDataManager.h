//
//  DiscoverDataManager.h
//  Instashop
//
//  Created by Josh Klobe on 11/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductAPIHandler.h"
#import "IGRequest.h"
#import "FeedRequestFinishedProtocol.h"
#import "DiscoverTableViewController.h"



@interface DiscoverDataManager : NSObject <FeedRequestFinishedProtocol, IGRequestDelegate>
{
    NSArray *sellersObjectsArray;
    NSMutableDictionary *unsortedDictionary;
    NSMutableArray *likedArray;
    NSMutableArray *contentArray;
    
    DiscoverTableViewController *referenceTableViewController;

}

+(DiscoverDataManager *)getSharedDiscoverDataManager;

@property (nonatomic, retain) NSArray *sellersObjectsArray;
@property (nonatomic, retain) NSMutableDictionary *unsortedDictionary;
@property (nonatomic, retain) NSMutableArray *likedArray;
@property (nonatomic, retain) NSMutableArray *contentArray;

@property (nonatomic, retain) DiscoverTableViewController *referenceTableViewController;

@end
