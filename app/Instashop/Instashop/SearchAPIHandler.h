//
//  SearchAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface SearchAPIHandler : RootAPIHandler

+(void)makeProductSearchRequestWithDelegate:(id)delegate withSearchCategoriesArray:(NSArray *)searchCategoriesArray withFreeformTextArray:(NSArray *)freeformTextArray;
+(void)makeSellerCategoryRequestWithDelegate:(id)delegate withCategoryString:(NSString *)categoryString withFreeformTextArray:(NSArray *)freeformTextArray;


@end
