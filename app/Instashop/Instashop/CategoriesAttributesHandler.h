//
//  CategoriesAttributesHandler.h
//  Instashop
//
//  Created by Josh Klobe on 6/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriesAttributesHandler : NSObject

+(CategoriesAttributesHandler *)sharedCategoryAttributesHandler;

-(NSArray *)getTopCategories;

@property (nonatomic, retain) NSDictionary *contentDict;
@end
