//
//  ProductCreateContainerObject.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCreateObject.h"

@interface ProductCreateContainerObject : NSObject
{
    ProductCreateObject *mainObject;
    NSArray *objectSizePermutationsArray;
    NSDictionary *tableViewCellSizeQuantityValueDictionary;
    
}

@property (nonatomic, strong) ProductCreateObject *mainObject;
@property (nonatomic, strong) NSArray *objectSizePermutationsArray;
@property (nonatomic, strong) NSDictionary *tableViewCellSizeQuantityValueDictionary;
@end
