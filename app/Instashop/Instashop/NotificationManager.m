//
//  NotificationManager.m
//  Instashop
//
//  Created by Josh Klobe on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NotificationManager.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"
#import "SellersAPIHandler.h"
#import "NotificationsAPIHandler.h"

@implementation NotificationManager

static NotificationManager *theSharedManager;

@synthesize followedIDsArray;
@synthesize allSellersArray;

+(NotificationManager *)getSharedManager
{
    if (theSharedManager == nil)
    {
        theSharedManager = [[NotificationManager alloc] init];
        theSharedManager.followedIDsArray = [[NSMutableArray alloc] initWithCapacity:0];
        theSharedManager.allSellersArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return theSharedManager;
}

-(void)handleNewUserPushNotifications
{
    [self getUserFollowersWithID:[InstagramUserObject getStoredUserObject].userID];
}

-(void)getUserFollowersWithID:(NSString *)instagramID
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
}



- (void)request:(IGRequest *)request didLoad:(id)result {
    
    if ([request.url rangeOfString:@"follows"].length > 0)
    {
        NSLog(@"follows returned");
        
        NSArray *dataArray = [result objectForKey:@"data"];
        
        if (self.followedIDsArray != nil)
            [self.followedIDsArray removeAllObjects];
        else
            self.followedIDsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i =0; i < [dataArray count]; i++)
            [self.followedIDsArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"id"]];
             
        [SellersAPIHandler makeGetAllSellersRequestWithDelegate:self];        
    }
}

-(void)sellersRequestFinishedWithResponseObject:(NSArray *)responseArray
{
    [self.allSellersArray removeAllObjects];
    
    for (int i = 0; i < [responseArray count]; i++)
        [self.allSellersArray addObject:[[responseArray objectAtIndex:i] objectForKey:@"instagram_id"]];

    
    NSLog(@"sellersRequestFinishedWithResponseObject: %@", self.allSellersArray);
    
    NSMutableArray *matchArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [self.allSellersArray count]; i++)
    {
        if ([self.followedIDsArray containsObject:[self.allSellersArray objectAtIndex:i]])
            [matchArray addObject:[self.allSellersArray objectAtIndex:i]];
    }
    
    
        [NotificationsAPIHandler makeUserJoinedNotificationWithNotificationArray:matchArray];

    NSLog(@"matchArray: %@", matchArray);
    
}
@end
