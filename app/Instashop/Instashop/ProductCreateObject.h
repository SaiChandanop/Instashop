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
    
    NSString *instagramPictureURLString;
    NSDictionary *instragramMediaInfoDictionary;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *retailValue;
@property (nonatomic, retain) NSArray *categoriesArray;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *retailPrice;
@property (nonatomic, retain) NSString *listPrice;
@property (nonatomic, retain) NSString *instashopPrice;
@property (nonatomic, retain) NSString *shippingWeight;

@property (nonatomic, retain) NSString *instagramPictureURLString;
@property (nonatomic, retain) NSDictionary *instragramMediaInfoDictionary;

@end
