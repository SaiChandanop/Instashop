//
//  ProductSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class ProductCreateViewController;

@interface ProductSelectTableViewController : UITableViewController <IGRequestDelegate>
{
    NSMutableArray *userMediaArray;
    
    ProductCreateViewController *parentController;
    
}
@property (nonatomic, retain) NSMutableArray *userMediaArray;
@property (nonatomic, retain) ProductCreateViewController *parentController;
@end
