//
//  NotificationsObject.h
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsObject : NSObject
{
    NSString *message;
    NSDictionary *dataDictionary;
}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *dataDictionary;

@end
