//
//  AttributesManager.m
//  Instashop
//
//  Created by Josh Klobe on 6/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AttributesManager.h"

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
/*
-(void)processAttributesString:(NSString *)myText
{
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    NSMutableDictionary *womensDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"z"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Dresses"];
    
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Lingerie"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Pants"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Shirts"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Shorts"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Skirts"];
    [womensDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:@"Dresses"];
    
    [retDict setObject:womensDictionary forKey:@"Womens"];
    
 
    NSLog(@"retDict: %@", retDict);
    [self.attributesDictionary setDictionary:retDict];
 
    
}
*/
-(void)processAttributesString:(NSString *)myText
{

//    [self AprocessAttributesString:myText];
    NSArray *linesArray = [myText componentsSeparatedByString:@"\n"];
    //        NSLog(@"linesArray: %@", linesArray);
    
    NSMutableArray *theParsingArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *currentKeysArray = [NSMutableArray arrayWithCapacity:0];
    
    
    int lastIndex = 99;
    for (int i = 0; i < [linesArray count]; i++)
    {
        NSArray *lineObjects = [[linesArray objectAtIndex:i] componentsSeparatedByString:@","];
        
        for (int j = 0; j < [lineObjects count]; j++)
            if ([[lineObjects objectAtIndex:j] length] > 0)
            {
                NSString *keyObject = [lineObjects objectAtIndex:j];
                
                if (j < lastIndex)
                {
                    if (j >= [currentKeysArray count])
                        [currentKeysArray addObject:keyObject];
                    else
                        [currentKeysArray replaceObjectAtIndex:j withObject:keyObject];
                    
                    lastIndex = j;
                }
                else
                {
                    if (j >= [currentKeysArray count])
                        [currentKeysArray addObject:keyObject];
                    else
                        [currentKeysArray replaceObjectAtIndex:j withObject:keyObject];
                    
                    lastIndex = j;
                    
                    if (lastIndex < [currentKeysArray count] - 1)
                        for (int k = 0; k < [currentKeysArray count]  - lastIndex; k++)
                            [currentKeysArray removeLastObject];
                    
                    NSArray *tempArray = [NSArray arrayWithArray:currentKeysArray];
                    lastIndex = 99;
                    [theParsingArray addObject:tempArray];
                }
            }
    }
    
    
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int i = 0; i < [theParsingArray count]; i++)
    {
        NSArray *objectsArray = [theParsingArray objectAtIndex:i];
        
        NSMutableDictionary *scopeDict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int j = 0; j < [objectsArray count]; j++)
        {
            NSString *key = [objectsArray objectAtIndex:j];
            if (j == 0)
            {
                if ([attributesDict objectForKey:key] == nil)
                    [attributesDict setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:key];
                
                scopeDict = [attributesDict objectForKey:key];
            }
            else
            {
                if ([scopeDict objectForKey:key] == nil)
                    [scopeDict setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:key];
                
                scopeDict = [scopeDict objectForKey:key];
            }
        }
        
    }
    

    
    NSDictionary *artDict = [attributesDict objectForKey:@"Art"];
    NSDictionary *postersDict = [artDict objectForKey:@"Posters"];

    [self.attributesDictionary setDictionary:attributesDict];
    
}



-(id)init
{
    self = [super init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"attributes1" ofType:@"csv"];
    if (filePath) {
        
        NSString *myText = [NSString stringWithContentsOfFile:filePath];
        [self processAttributesString:myText];
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
