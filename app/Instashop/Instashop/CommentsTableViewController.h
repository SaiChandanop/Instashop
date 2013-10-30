//
//  CommentsTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PurchasingViewController;

@interface CommentsTableViewController : UITableViewController
{
    PurchasingViewController *parentController;
    NSArray *commentsDataArray;
}

@property (nonatomic, retain) PurchasingViewController *parentController;
@property (nonatomic, retain) NSArray *commentsDataArray;
@end
