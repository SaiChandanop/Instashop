//
//  ProductSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectSelectTableViewController.h"

@interface ProductSelectTableViewController : ObjectSelectTableViewController
{
    int checkCountup;
}
@property (nonatomic, assign) int checkCountup;
@end
