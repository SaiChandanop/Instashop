//
//  InstagramUserObject.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "InstagramUserObject.h"
#import "GroupDiskManager.h"

#define CURRENT_USER_OBJECT_STORAGE_KEY @"CURRENT_USER_OBJECT_STORAGE_KEY"

@implementation InstagramUserObject

@synthesize bio;
@synthesize counts;
@synthesize fullName;
@synthesize userID;
@synthesize profilePicture;
@synthesize username;
@synthesize website;


-(id)initWithDictionary:(NSDictionary *)theDict
{
    self = [super init];
    
    self.bio = [theDict objectForKey:@"bio"];
    self.counts = [theDict objectForKey:@"counts"];
    self.fullName = [theDict objectForKey:@"full_name"];
    self.userID = [theDict objectForKey:@"id"];
    self.profilePicture = [theDict objectForKey:@"profile_picture"];
    self.username = [theDict objectForKey:@"username"];
    self.website = [theDict objectForKey:@"website"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.bio forKey:@"bio"];
    [encoder encodeObject:self.counts forKey:@"counts"];
    [encoder encodeObject:self.fullName forKey:@"fullName"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.profilePicture forKey:@"profilePicture"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.website forKey:@"website"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init])
    {
        self.bio = [decoder decodeObjectForKey:@"bio"];
        self.counts = [decoder decodeObjectForKey:@"counts"];
        self.fullName = [decoder decodeObjectForKey:@"fullName"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.profilePicture = [decoder decodeObjectForKey:@"profilePicture"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.website = [decoder decodeObjectForKey:@"website"];        
    }
    return self;
}


+(InstagramUserObject *)getStoredUserObject
{
    return [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:CURRENT_USER_OBJECT_STORAGE_KEY];
}

-(NSString *)description
{
    NSString *endlineTerminator = @"\r";
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    [string appendString:[NSString stringWithFormat:@"%@InstagramUserObject%@", endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"bio: %@%@", self.bio, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"counts: %@%@", self.counts, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"fullName: %@%@", self.fullName, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"userID: %@%@", self.userID, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"profilePicture: %@%@", self.profilePicture, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"username: %@%@", self.username, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"website: %@%@", self.website, endlineTerminator]];
    return string;
}

@end
