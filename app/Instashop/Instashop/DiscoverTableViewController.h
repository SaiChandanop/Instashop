//
//  DiscoverTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedRequestFinishedProtocol.h"
#import "IGRequest.h"

@class DiscoverViewController;

@interface DiscoverTableViewController : UITableViewController <FeedRequestFinishedProtocol, IGRequestDelegate>
{
    DiscoverViewController *parentController;
    NSArray *sellersObjectsArray;
    
    NSMutableDictionary *unsortedDictionary;
    NSMutableArray *likedArray;
    NSMutableArray *contentArray;
    
}
@property (nonatomic, retain) DiscoverViewController *parentController;
@property (nonatomic, retain) NSArray *sellersObjectsArray;

@property (nonatomic, retain) NSMutableDictionary *unsortedDictionary;
@property (nonatomic, retain) NSMutableArray *likedArray;
@property (nonatomic, retain) NSMutableArray *contentArray;
@end
