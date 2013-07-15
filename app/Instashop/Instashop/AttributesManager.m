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
    }
    return theManager;
}



-(id)init
{
    self = [super init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"attributes1" ofType:@"csv"];
    if (filePath) {
        
        self.attributesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        NSString *myText = [NSString stringWithContentsOfFile:filePath];
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
        
        ///        NSLog(@"attributesDict: %@", attributesDict);
        
        [self.attributesDictionary setDictionary:attributesDict];
        
    }
    return self;
}

-(NSArray *)getCategoriesWithArray:(NSArray *)theArray
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
    
    NSLog(@"dict: %@", dict);
    
    NSArray *retAR = [dict allKeys];
                      
    if ([[dict allKeys] count] == 0)
        return nil;
    if ([[dict allKeys] count] == 1)
        if ([[[dict allKeys] objectAtIndex:0] rangeOfString:@"|||"].length > 0)
            retAR = nil;
        
    return retAR;
}




@end
