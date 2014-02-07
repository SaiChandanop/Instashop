//
//  NotificationsTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsObject.h"

@class NotificationsViewController;
@interface NotificationsTableViewCell : UITableViewCell
{
    NotificationsObject *notificationsObject;
    
    UILabel *usernameLabel;
    UILabel *messageLabel;
    UILabel *timeLabel;
    UIImageView *profileImageView;
    
    NotificationsViewController *parentController;
}

-(IBAction)profileButtonHit;
-(IBAction)notificationsButtonHit;

-(void)loadContentWithDataDictionary:(NSDictionary *)dataDictionary;
-(void)loadWithNotificationsObject:(NotificationsObject *)theObject;
-(void)clearSubviews;

@property (nonatomic, strong) NotificationsObject *notificationsObject;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) NotificationsViewController *parentController;
@end
 