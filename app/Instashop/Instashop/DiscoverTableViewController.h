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
#import "JKProgressView.h"
@class DiscoverViewController;

@interface DiscoverTableViewController : UITableViewController <FeedRequestFinishedProtocol, IGRequestDelegate>
{
    DiscoverViewController *parentController;
    JKProgressView *jkProgressView;
    NSMutableArray *contentArray;
    
}

-(void)doPresentData;

@property (nonatomic, strong) DiscoverViewController *parentController;
@property (nonatomic, strong) JKProgressView *jkProgressView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end
