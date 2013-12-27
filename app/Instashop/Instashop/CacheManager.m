//
//  CacheManager.m
//  Instashop
//
//  Created by Josh Klobe on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CacheManager.h"
#import "ImageAPIHandler.h"

@implementation CacheManager

@synthesize mediaCache;

static CacheManager *theCacheManager;

+(CacheManager *)getSharedCacheManager
{
    if (theCacheManager == nil)
    {
        theCacheManager = [[CacheManager alloc] init];
        theCacheManager.mediaCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return theCacheManager;
}

-(UIImage *)getImageWithURL:(NSString *)theURL
{
    return [self.mediaCache objectForKey:theURL];
}

-(void)setCacheObject:(UIImage *)theObject withKey:(NSString *)theKey
{
    [self.mediaCache setObject:theObject forKey:theKey];
}

-(void)precacheWithDataSet:(NSArray *)dataSetArray withIndexPath:(NSIndexPath *)theIndexPath
{
//    NSLog(@"precacheWithDataSet, indexPath.row: %d", theIndexPath.row);
    
    NSMutableArray *precacheArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = theIndexPath.row * 3; i < theIndexPath.row * 3 + 27 && i < [dataSetArray count]; i++)
    {
        [precacheArray addObject:[dataSetArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < [precacheArray count]; i++)
    {
        NSString *precacheString = [[precacheArray objectAtIndex:i] objectForKey:@"products_url"];
        if (precacheString != nil)
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:precacheString withImageView:nil];
        
    }
//    NSLog(@"precacheArray: %@", precacheArray);
}


@end
