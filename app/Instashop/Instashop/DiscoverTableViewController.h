//
//  DiscoverTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedRequestFinishedProtocol.h"
@class DiscoverViewController;

@interface DiscoverTableViewController : UITableViewController <FeedRequestFinishedProtocol>
{
    DiscoverViewController *parentController;
    NSArray *sellersObjectsArray;
    
    NSArray *contentArray;
    
}
@property (nonatomic, retain) DiscoverViewController *parentController;
@property (nonatomic, retain) NSArray *sellersObjectsArray;

@property (nonatomic, retain) NSArray *contentArray;
@end
