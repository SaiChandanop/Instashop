//
//  AttributesManager.h
//  Instashop
//
//  Created by Josh Klobe on 6/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (indexKeyedDictionaryExtension)
- (NSDictionary *)indexKeyedDictionary;
@end


@interface AttributesManager : NSObject

+(AttributesManager *)getSharedAttributesManager;

-(NSArray *)getShopsCategories;
-(NSArray *)getCategoriesWithArray:(NSArray *)theArray;
-(NSArray *)getSizesWithArray:(NSArray *)theArray;

@property (nonatomic, retain) NSMutableDictionary *attributesDictionary;


@end
