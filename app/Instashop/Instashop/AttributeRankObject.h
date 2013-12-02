//
//  AttributeRankObject.h
//  Instashop
//
//  Created by Josh Klobe on 12/2/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributeRankObject : NSObject
{
    NSString *attributeString;
    int rank;
}
@property (nonatomic, retain) NSString *attributeString;
@property (nonatomic, assign) int rank;
@end
