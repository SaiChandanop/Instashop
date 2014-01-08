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

-(IBAction)profileButtonHit;
-(IBAction)notificationsButtonHit;

-(void)loadWithNotificationsObject:(NotificationsObject *)theObject;
-(void)clearSubviews;

@property (nonatomic, strong) NotificationsObject *notificationsObject;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;
@end
 