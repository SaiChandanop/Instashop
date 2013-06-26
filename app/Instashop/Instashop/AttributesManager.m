//
//  AttributesManager.m
//  Instashop
//
//  Created by Josh Klobe on 6/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AttributesManager.h"


@implementation AttributesManager


static AttributesManager *theManager;

@synthesize attributesArray;

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"attributes" ofType:@"csv"];
    if (filePath) {
        
        self.attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSString *myText = [NSString stringWithContentsOfFile:filePath];
        
        NSMutableDictionary *outermostDictionary = nil;
        
        NSString *innerKey = nil;
        
        NSArray *linesArray = [myText componentsSeparatedByString:@"\n"];
        
        for (int i = 0; i < [linesArray count]; i++)
        {
            NSArray *lineObjects = [[linesArray objectAtIndex:i] componentsSeparatedByString:@","];
            
            if ([lineObjects count] == 3)
            {
                NSLog(@"lineObjects[%d]: %@", i, lineObjects);
                
                if ([[lineObjects objectAtIndex:0] length] > 0)
                {
                    if (outermostDictionary != nil)
                        [self.attributesArray addObject:outermostDictionary];

                    outermostDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
                    [outermostDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:[lineObjects objectAtIndex:0]];
                }
                else if ([[lineObjects objectAtIndex:1] length] > 0)
                {
                    
                    NSMutableDictionary *outermostContentDictionary = [outermostDictionary objectForKey:[[outermostDictionary allKeys] objectAtIndex:0]];
                    
                    innerKey = [lineObjects objectAtIndex:1];
                    
                    NSMutableDictionary *theDictionary = [outermostContentDictionary objectForKey:innerKey];
                    
                    if (theDictionary == nil)
                    {
                        [outermostContentDictionary setObject:[[NSMutableDictionary alloc] initWithCapacity:0] forKey:innerKey];
                    }
                }
                else if ([[lineObjects objectAtIndex:2] length] > 0)
                {                                        
                    
                    NSMutableDictionary *outermostContentDictionary = [outermostDictionary objectForKey:[[outermostDictionary allKeys] objectAtIndex:0]];
                    NSMutableDictionary *innerDictionary = [outermostContentDictionary objectForKey:innerKey];
                    
                    NSString *key = [lineObjects objectAtIndex:2];
                    NSLog(@"key: %@", key);
                    NSLog(@"innerKey: %@", innerKey);
                    
                    [innerDictionary setObject:[NSMutableDictionary dictionaryWithCapacity:0] forKey:key];
                    
                }
            }
        }
        if (outermostDictionary != nil)
        {
            [self.attributesArray addObject:outermostDictionary];
        }
    }
    
    NSLog(@"attributesArray: %@", attributesArray);
    return self;
}
@end
