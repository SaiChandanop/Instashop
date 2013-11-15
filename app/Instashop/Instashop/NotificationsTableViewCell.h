//
//  NotificationsTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsObject.h"
#import "IGRequest.h"
#import "NotificationsObject.h"

@interface NotificationsTableViewCell : UITableViewCell <IGRequestDelegate>
{
    NotificationsObject *notificationsObject;
    
    UILabel *usernameLabel;
    UILabel *messageLabel;
    UILabel *timeLabel;
    UIImageView *profileImageView;
}

-(void)loadWithNotificationsObject:(NotificationsObject *)theObject;
-(void)clearSubviews;

@property (nonatomic, retain) NotificationsObject *notificationsObject;

@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UIImageView *profileImageView;
@end
 