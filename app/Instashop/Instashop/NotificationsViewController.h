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

-(void)loadNotifications;

@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end
