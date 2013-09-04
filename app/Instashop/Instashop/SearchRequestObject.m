//
//  SearchRequestObject.m
//  Instashop
//
//  Created by Josh Klobe on 9/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchRequestObject.h"

@implementation SearchRequestObject

@synthesize searchCategoriesArray;
@synthesize searchFreeTextArray;

-(id)initWithCategoriesArray:(NSArray *)theCategoriesArray withFreeTextArray:(NSArray *)theFreeTextArray
{
    self = [super init];

    self.searchCategoriesArray = [[NSArray alloc] initWithArray:theCategoriesArray];
    self.searchFreeTextArray = [[NSArray alloc] initWithArray:theFreeTextArray];
    
    return self;
}

@end
