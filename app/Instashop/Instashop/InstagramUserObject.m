//
//  InstagramUserObject.m
//  Instashop
//  Container object for the logged in user's Instagram data.
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "InstagramUserObject.h"
#import "GroupDiskManager.h"
#import "Utils.h"

#define CURRENT_USER_OBJECT_STORAGE_KEY @"CURRENT_USER_OBJECT_STORAGE_KEY"

@implementation InstagramUserObject

@synthesize bio;
@synthesize counts;
@synthesize fullName;
@synthesize userID;
@synthesize profilePicture;
@synthesize username;
@synthesize website;
@synthesize zencartID;


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
    self.zencartID = [theDict objectForKey:@"zencartID"];
    
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
    [encoder encodeObject:self.zencartID forKey:@"zencartID"];
    
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
        self.zencartID = [decoder decodeObjectForKey:@"zencartID"];        
    }
    return self;
}

-(NSString *)userObjectAsPostString
{
    NSLog(@"self.username: %@", self.username);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    [string appendString:[NSString stringWithFormat:@"bio=%@", self.bio]];
    [string appendString:[NSString stringWithFormat:@"&"]];
//    [string appendString:[NSString stringWithFormat:@"counts=%@", self.counts]];
//    [string appendString:[NSString stringWithFormat:@"@&"]];
    [string appendString:[NSString stringWithFormat:@"fullName=%@", self.fullName]];
    [string appendString:[NSString stringWithFormat:@"&"]];
    [string appendString:[NSString stringWithFormat:@"userID=%@", self.userID]];
    [string appendString:[NSString stringWithFormat:@"&"]];
    [string appendString:[NSString stringWithFormat:@"profilePicture=%@", self.profilePicture]];
    [string appendString:[NSString stringWithFormat:@"&"]];
    [string appendString:[NSString stringWithFormat:@"username=%@", self.username]];
    [string appendString:[NSString stringWithFormat:@"&"]];
    [string appendString:[NSString stringWithFormat:@"website=%@", [Utils getEscapedStringFromUnescapedString:self.website]]];
    
    return string;
}

+(void)deleteStoredUserObject
{
    [[GroupDiskManager sharedManager] deleteFile:CURRENT_USER_OBJECT_STORAGE_KEY error:nil];
}

+(InstagramUserObject *)getStoredUserObject
{
    return [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:CURRENT_USER_OBJECT_STORAGE_KEY];
}

-(void)setAsStoredUser:(InstagramUserObject *)theObject
{

    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:theObject withKey:CURRENT_USER_OBJECT_STORAGE_KEY];
}

-(NSString *)description
{
    NSString *endlineTerminator = @"\r";
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    [string appendString:[NSString stringWithFormat:@"%@InstagramUserObject%@", endlineTerminator, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"bio: %@%@", self.bio, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"counts: %@%@", self.counts, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"fullName: %@%@", self.fullName, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"userID: %@%@", self.userID, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"profilePicture: %@%@", self.profilePicture, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"username: %@%@", self.username, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"website: %@%@", self.website, endlineTerminator]];
    [string appendString:[NSString stringWithFormat:@"zencartID: %@%@", self.zencartID, endlineTerminator]];
    return string;
}

@end
