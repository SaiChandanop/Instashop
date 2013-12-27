//
//  CacheManager.m
//  Instashop
//
//  Created by Josh Klobe on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CacheManager.h"

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




@end
