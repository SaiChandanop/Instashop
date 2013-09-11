//
//  DiscoverTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoverViewController;

@interface DiscoverTableViewController : UITableViewController
{
    DiscoverViewController *parentController;
    NSArray *sellersObjectsArray;
    
}
@property (nonatomic, retain) DiscoverViewController *parentController;
@property (nonatomic, retain) NSArray *sellersObjectsArray;

@end
