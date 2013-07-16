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
}

@property (nonatomic, retain) ProductCreateObject *mainObject;
@property (nonatomic, retain) NSArray *objectSizePermutationsArray;

@end
