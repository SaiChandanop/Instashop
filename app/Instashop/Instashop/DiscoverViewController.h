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

    UIScrollView *theScrollView;
    
    NSString *currentTopCategorySelection;
    
}

-(void)topCategorySelectedWithString:(NSString *)theString;

@property (nonatomic, retain) DiscoverTopCategoryTableViewController *discoverTopCategoryTableViewController;

@property (nonatomic, retain) UIScrollView *theScrollView;

@property (nonatomic, retain) NSString *currentTopCategorySelection;

@end
