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

    NSTimer *catchoutTimer;
    int countup;
}

+(DiscoverDataManager *)getSharedDiscoverDataManager;
-(void)updateData;

@property (nonatomic, strong) NSArray *sellersObjectsArray;
@property (nonatomic, strong) NSMutableDictionary *unsortedDictionary;
@property (nonatomic, strong) NSMutableArray *likedArray;
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) DiscoverTableViewController *referenceTableViewController;

@property (nonatomic, strong) NSTimer *catchoutTimer;
@property (nonatomic, assign) int countup;

@end
