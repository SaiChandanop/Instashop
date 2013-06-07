//
//  DiscoverViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverTableViewController.h"


@interface DiscoverViewController : UIViewController
{
    DiscoverTableViewController *discoverTopCategoryTableViewController;

    UIScrollView *theScrollView;
    
    NSString *currentTopCategorySelection;
    
}

-(void)tableOptionSelectedWithTableViewController:(DiscoverTableViewController *)theController withOption:(NSString *)theOption;

@property (nonatomic, retain) DiscoverTableViewController *discoverTopCategoryTableViewController;

@property (nonatomic, retain) UIScrollView *theScrollView;

@property (nonatomic, retain) NSString *currentTopCategorySelection;

@end
