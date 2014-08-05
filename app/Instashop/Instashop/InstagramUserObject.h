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

@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSDictionary *counts;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *zencartID;
@end
