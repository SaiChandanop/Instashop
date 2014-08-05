//
//  CacheManager.h
//  Instashop
//
//  Created by Josh Klobe on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
{
    NSMutableDictionary *mediaCache;
}

+(CacheManager *)getSharedCacheManager;

-(UIImage *)getImageWithURL:(NSString *)theURL;
-(void)setCacheObject:(UIImage *)theObject withKey:(NSString *)theKey;
-(void)precacheWithDataSet:(NSArray *)dataSetArray withIndexPath:(NSIndexPath *)theIndexPath;
-(void)destroyCachedImageWithURL:(NSString *)theURL;
@property (nonatomic, strong) NSMutableDictionary *mediaCache;

@end
