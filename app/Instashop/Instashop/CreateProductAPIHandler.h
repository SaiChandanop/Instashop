//
//  CreateProductAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "ProductCreateObject.h"
#import "ProductCreateContainerObject.h"

@interface CreateProductAPIHandler : RootAPIHandler

+(void)createProductContainerObject:(id)delegate withProductCreateObject:(ProductCreateContainerObject *)theProductCreateObject;
+(void)createProductSizeQuantityObjects:(id)delegate withProductObject:(ProductCreateObject *)theProductCreateObject withProductID:(NSString *)productID;
@end
