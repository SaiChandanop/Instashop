//
//  NotificationManager.h
//  Instashop
//
//  Created by Josh Klobe on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGRequest.h"
#import "SellersRequestFinishedProtocol.h"
@interface NotificationManager : NSObject <IGRequestDelegate, SellersRequestFinishedProtocol>
{
    NSMutableArray *followedIDsArray;
    NSMutableArray *allSellersArray;
    
}

+(NotificationManager *)getSharedManager;
-(void)handleNewUserPushNotifications;

@property (nonatomic, retain) NSMutableArray *followedIDsArray;
@property (nonatomic, retain) NSMutableArray *allSellersArray;
@end
