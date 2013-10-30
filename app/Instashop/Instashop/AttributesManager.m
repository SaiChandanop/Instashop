//
//  AttributesManager.m
//  Instashop
//
//  Created by Josh Klobe on 6/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AttributesManager.h"
#import "GroupDiskManager.h"


@implementation NSArray (indexKeyedDictionaryExtension)

- (NSDictionary *)indexKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) { objectKeys[index] = [NSNumber numberWithUnsignedInteger:index]; }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

@end



@implementation AttributesManager


static AttributesManager *theManager;

@synthesize attributesDictionary;

+(AttributesManager *)getSharedAttributesManager;
{
    if (theManager == nil)
    {
        theManager = [[AttributesManager alloc] init];
        theManager.attributesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return theManager;
}




-(void)processAttributesString:(NSString *)myText
{
    
    NSData* plistData = [myText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if(!plist){
        NSLog(@"Error: %@",error);
        [error release];
    }

    self.attributesDictionary = [[NSMutableDictionary alloc] initWithDictionary:plist];   
}





-(id)init
{
    self = [super init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"attributes1" ofType:@"csv"];
    if (filePath) {
        
        NSString *myText = [NSString stringWithContentsOfFile:filePath];
//        [self processAttributesString:myText];
    }
            return self;
}

-(NSArray *)getShopsCategories
{
    return [NSArray arrayWithObjects:@"Art", @"Books & Media", @"Fashion", @"Health & Beauty", @"Home", @"Music", @"Sports", @"Technology", nil];
}

-(NSArray *)getCategoriesWithArray:(NSArray *)theArray
{
//    NSLog(@"attributesDictionary: %@", self.attributesDictionary);
    NSDictionary *dict = nil;
    
    if ([theArray count] == 0)
        return [self.attributesDictionary allKeys];
    
    else
    {
        for (int i = 0; i < [theArray count]; i++)
        {
            NSString *theKey = [theArray objectAtIndex:i];
            if (i == 0)
                dict = [self.attributesDictionary objectForKey:theKey];
            else
                dict = [dict objectForKey:theKey];
            
        }
    }
    
//    NSLog(@"dict: %@", dict);
    
    NSArray *retAR = [dict allKeys];
                      
    if ([[dict allKeys] count] == 0)
        return nil;
    if ([[dict allKeys] count] == 1)
        if ([[[dict allKeys] objectAtIndex:0] rangeOfString:@"|||"].length > 0)
            retAR = nil;
        
    return retAR;
}

-(NSArray *)getSizesWithArray:(NSArray *)theArray
{
    NSDictionary *dict = nil;
    
    if ([theArray count] == 0)
        return [self.attributesDictionary allKeys];
    
    else
    {
        for (int i = 0; i < [theArray count]; i++)
        {
            NSString *theKey = [theArray objectAtIndex:i];
            if (i == 0)
                dict = [self.attributesDictionary objectForKey:theKey];
            else
                dict = [dict objectForKey:theKey];
            
        }
    }
    
    NSArray *retAR = nil;
    
    if ([[dict allKeys] count] == 1)
        if ([[[dict allKeys] objectAtIndex:0] rangeOfString:@"|||"].length > 0)
        {
            retAR = [NSArray arrayWithArray:[[[dict allKeys] objectAtIndex:0] componentsSeparatedByString:@"|||"]];

        }
    

    
    return retAR;
}



@end
