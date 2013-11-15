//
//  NotificationsTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsObject.h"

@interface NotificationsTableViewCell : UITableViewCell
{
    UILabel *messageLabel;
    UILabel *timeLabel;
}

-(void)loadWithNotificationsObject:(NotificationsObject *)theObject;


@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@end
 