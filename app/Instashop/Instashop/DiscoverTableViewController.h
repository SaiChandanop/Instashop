//
//  DiscoverTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoverViewController;

@interface DiscoverTableViewController : UITableViewController
{
    DiscoverViewController *parentController;
    NSArray *contentArray;
    
}

-(void)setContentWithArray:(NSArray *)theArray;

@property (nonatomic, retain) DiscoverViewController *parentController;
@property (nonatomic, retain) NSArray *contentArray;
           
@end
