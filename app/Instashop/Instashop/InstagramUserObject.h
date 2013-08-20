//
//  InstagramUserObject.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUserObject : NSObject <NSCoding>
{
    NSString *bio;
    NSDictionary *counts;
    NSString *fullName;
    NSString *userID;
    NSString *profilePicture;
    NSString *username;
    NSString *website;
    NSString *zencartID;
        
}

+(void)deleteStoredUserObject;
-(NSString *)userObjectAsPostString;
-(id)initWithDictionary:(NSDictionary *)theDict;
+(InstagramUserObject *)getStoredUserObject;
-(void)setAsStoredUser:(InstagramUserObject *)theObject;

@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSDictionary *counts;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *profilePicture;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *zencartID;
@end
