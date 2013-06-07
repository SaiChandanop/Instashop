//
//  DiscoverTopCategoryTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoverViewController;

@interface DiscoverTopCategoryTableViewController : UITableViewController
{
    DiscoverViewController *parentController;
    
    NSArray *categoriesArray;
}

@property (nonatomic, retain) DiscoverViewController *parentController;

@property (nonatomic, retain) NSArray *categoriesArray;
@end
