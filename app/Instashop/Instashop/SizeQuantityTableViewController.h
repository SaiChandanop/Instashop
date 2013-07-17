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
    NSArray *sizesArray;
    NSMutableArray *sizeSetValuesArray;
}

-(void)cellSelectedValue:(NSString *)value withIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSArray *sizesArray;
@property (nonatomic, retain) NSMutableArray *sizeSetValuesArray;

@end
