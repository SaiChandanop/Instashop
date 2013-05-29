//
//  ProductAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface ProductAPIHandler : RootAPIHandler

+(void)createNewProductWithDelegate:(id)delegate withInstagramDataObject:(NSDictionary *)productDict withTitle:(NSString *) title withQuantity:(NSString *)quantity withModel:(NSString *)model withPrice:(NSString *)price withWeight:(NSString *)weight withDescription:(NSString *)description;

@end
