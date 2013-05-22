//
//  GroupDiskManager.h
//  Calendar
//
//  Created by Jay Canty on 4/19/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>



#define STORED_FACEBOOK_USER_KEY @"STORED_FACEBOOK_USER_KEY"

@interface GroupDiskManager : NSObject

+(GroupDiskManager *)sharedManager;

- (void) saveDataToDiskWithObject:(id)object withKey:(NSString *)key;
- (id) loadDataFromDiskWithKey:(NSString *)key;

-(NSString *)getFolderPath;

@end
