//
//  NotificationsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsFinishedProtocol.h"

@interface NotificationsViewController : UIViewController <NotificationsFinishedProtocol, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *theTableView;
    NSMutableArray *contentArray;
    
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSMutableArray *contentArray;
@end
