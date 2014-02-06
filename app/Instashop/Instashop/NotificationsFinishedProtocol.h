//
//  NotificationsFinishedProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotificationsFinishedProtocol <NSObject>

-(void)notificationClearDidFinish;
-(void)notificationsCountDidFinishWithDictionary:(NSDictionary *)theDictionary;
-(void)notificationsDidFinishWithArray:(NSArray *)theNotificationsArray;

@end
