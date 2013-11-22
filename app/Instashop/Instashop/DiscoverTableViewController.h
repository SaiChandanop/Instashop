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
    
    NSMutableArray *contentArray;
    
}
@property (nonatomic, retain) DiscoverViewController *parentController;
@property (nonatomic, retain) NSMutableArray *contentArray;
@end
