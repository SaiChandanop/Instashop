//
//  SizeQuantityTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeQuantityTableViewController : UITableViewController
{
    NSMutableArray *sizeQuantityTableViewCells;
    
    NSArray *sizesArray;
    
}

@property (nonatomic, retain) NSMutableArray *sizeQuantityTableViewCells;
@property (nonatomic, retain) NSArray *sizesArray;

@end
