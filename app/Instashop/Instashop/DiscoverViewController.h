//
//  DiscoverViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverTopCategoryTableViewController.h"


@interface DiscoverViewController : UIViewController
{
    DiscoverTopCategoryTableViewController *discoverTopCategoryTableViewController;
    
}

@property (nonatomic, retain) DiscoverTopCategoryTableViewController *discoverTopCategoryTableViewController;
@end
