//
//  ProductCreateObject.h
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCreateObject : NSObject
{
    NSString *title;
    NSString *description;
    NSString *retailValue;
    NSArray *categoriesArray;
    NSString *size;
    NSString *quantity;
    NSString *retailPrice;
    NSString *listPrice;
    NSString *instashopPrice;
    NSString *shippingWeight;
    NSString *referenceURLString;
    NSString *instagramPictureURLString;
    NSDictionary *instragramMediaInfoDictionary;
    
    NSString *editingReferenceID;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *retailValue;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *retailPrice;
@property (nonatomic, strong) NSString *listPrice;
@property (nonatomic, strong) NSString *instashopPrice;
@property (nonatomic, strong) NSString *shippingWeight;
@property (nonatomic, strong) NSString *referenceURLString;
@property (nonatomic, strong) NSString *instagramPictureURLString;
@property (nonatomic, strong) NSDictionary *instragramMediaInfoDictionary;

@property (nonatomic, strong) NSString *editingReferenceID;
@end
