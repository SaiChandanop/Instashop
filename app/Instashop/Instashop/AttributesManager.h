//
//  AttributesManager.h
//  Instashop
//
//  Created by Josh Klobe on 6/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributesManager : NSObject

+(AttributesManager *)getSharedAttributesManager;

@property (nonatomic, retain) NSMutableArray *attributesArray;
@end
