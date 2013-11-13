//
//  MediaLikedObject.h
//  Instashop
//
//  Created by Josh Klobe on 11/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaLikedObject : NSObject
{
    NSString *mediaID;
    int likedCount;
}
@property (nonatomic, retain) NSString *mediaID;
@property (nonatomic, assign) int likedCount;
@end
