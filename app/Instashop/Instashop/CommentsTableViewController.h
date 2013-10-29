//
//  CommentsTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewController : UITableViewController
{
    NSArray *commentsDataArray;
}
@property (nonatomic, retain) NSArray *commentsDataArray;
@end
